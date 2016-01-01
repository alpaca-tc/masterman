module Masterman
  class Relation
    include Enumerable
    extend Forwardable

    delegate %i(each last) => :to_a
    alias_method :exists?, :any?

    %i(first last take find_by).each do |method_name|
      define_method("#{method_name}!") { |*args| find_or_error!(method_name, *args) }
    end

    def initialize(klass, records = [])
      @klass = klass
      @instances = to_instances(records)
    end

    def find(id)
      @instances[id] || raise(RecordNotFound.new('missing record'))
    end

    def find_by(attributes)
      @instances.each do |_, record|
        return record if attributes.all? { |key, value| record[key] == value }
      end

      nil
    end

    def pluck(*column_names)
      if column_names.one?
        all.map { |record| record[column_names.first] }
      else
        all.map do |record|
          column_names.map { |name| record[name] }
        end
      end
    end

    def ids
      pluck(@klass.masterman.primary_key)
    end

    def many?
      count > 1
    end

    def all
      to_a
    end

    def to_a
      @instances.values
    end

    private

    def find_or_error!(method_name, *args)
      public_send(method_name, *args) || raise(RecordNotFound.new("Couldn't find by #{method_name}"))
    end

    # [{ primary_key => instance, primary_key => instance, ... }]
    def to_instances(records)
      records.each_with_object({}) do |attributes, memo|
        record = @klass.new(attributes)
        memo[record[@klass.masterman.primary_key]] = record
      end
    end
  end
end
