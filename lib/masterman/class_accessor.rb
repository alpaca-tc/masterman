module Masterman
  module ClassAccessor
    extend ActiveSupport::Concern

    class GeneratedAttributeReaders < Module; end

    included do
      class_attribute :generated_cattr_readers
    end

    def mount_class_attributes!
      initialize_generated_cattr_readers unless mountable_class_attributes?
    end

    def attributes
      masterman.attr_readers.each_with_object({}) do |attr, memo|
        value = public_send(attr)
        memo[attr.to_s] = value if value
      end
    end

    def [](key)
      public_send(key)
    end

    private

    def mountable_class_attributes?
      self.class.generated_cattr_readers && self.class.cloader && self.class.cattr_readers.length > 0
    end

    def initialize_generated_cattr_readers
      self.generated_cattr_readers = GeneratedAttributeReaders.new
      self.model_class.extend(generated_cattr_readers)
      define_cattributes
    end

    def define_cattributes
      readers = cattr_readers

      generated_cattr_readers.module_eval do
        readers.each do |reader|
          define_method reader do
            mounted = masterman.class_loader.all
            mounted[reader.to_s] || mounted[reader.to_sym]
          end
        end
      end
    end
  end
end
