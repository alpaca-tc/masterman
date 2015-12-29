module Masterman
  module Mountable
    attr_writer :primary_key
    attr_reader :loader

    def mount(options = {})
      @loader = Loader.build(options)
    end

    def primary_key
      @primary_key || :id
    end

    def all
      to_instances(loader.all)
    end

    private

    # [{ primary_key => instance, primary_key => instance, ... }]
    def to_instances(records)
      records.each_with_object({}) do |attributes, memo|
        record = model_class.new(attributes)
        memo[record[primary_key]] = record
      end
    end
  end
end
