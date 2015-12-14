module Masterman
  module Mountable
    class MastermanError < StandardError; end
    class RecordNotFound < MastermanError; end

    module Attributes
      extend Extendable

      def attributes
        self.class.attribute_methods.each_with_object({}) do |attr, memo|
          value = public_send(attr)
          memo[attr.to_s] = value if value
        end
      end

      def assign_attributes(attributes)
        attributes.each do |key, value|
          public_send("#{key}=", value)
        end
      end

      def [](key)
        public_send(key)
      end

      def []=(key, value)
        public_send("#{key}=", value)
      end

      module ClassMethods
        def attribute_methods
          @attribute_methods || []
        end

        def attribute_accessor(*attrs)
          @attribute_methods ||= []
          @attribute_methods += attrs
          attr_accessor(*attrs)
        end
      end
    end

    module Collection
      extend Extendable

      module ClassMethods
        def self.extended(klass)
          super

          klass.class_eval do
            include Enumerable

            class << self
              extend Forwardable

              delegate [:each] => :to_a

              delegate %i(
                delete_at select! delete_if compact! map! uniq! reverse! reject!
                flatten! sort! sort_by! collect! shuffle! keep_if rotate! slice
              ) => :spawn

              delegate %i(
                combination fill index rassoc reverse_each uniq
                any? compact find_index insert pack reject rindex shuffle take
                assoc first inspect permutation rotate take_while unshift
                at concat each flatten join pop repeated_combination size values_at
                bsearch count each_index sample to_ary zip
                clear cycle empty? frozen? last pretty_print_cycle replace select slice! to_h
                == collect delete eql? hash length product reverse sort to_s
                fetch include? map push transpose
              ) => :to_a
            end
          end
        end

        def find(id)
          optimized_array[id] || raise(RecordNotFound.new('missing record'))
        end
      end
    end

    module ClassMethods
      def mount_data(options)
        @_mount_options = options
      end

      def primary_key=(val)
        @primary_key = val
      end

      def primary_key
        @primary_key || :id
      end

      def to_a
        optimized_array.values
      end

      # DO NOT LOAD LARGE FILE
      def optimized_array
        @optimized_array ||= load_file
      end

      def spawn
        to_a.dup
      end

      private

      def load_file
        fname = @_mount_options[:from]
        loader = Loader.for(@_mount_options[:loader])

        loader.read(fname).each_with_object({}) do |attributes, memo|
          record = new(attributes)
          memo[record[primary_key]] = record
        end
      end
    end

    extend Extendable

    def self.included(klass)
      super
      klass.include(Attributes)
      klass.include(Collection)
    end
  end
end
