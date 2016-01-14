require 'masterman/mountable'
require 'masterman/reflection'
require 'masterman/association'
require 'masterman/collection'

module Masterman
  module InstanceAccessor
    extend ActiveSupport::Concern

    included do
      class_attribute :generated_attr_readers, :generated_cattr_readers
    end

    class_methods do
      def mount_class_attributes!
        initialize_generated_cattr_readers unless mountable_class_attributes?
      end

      private

      def mountable_class_attributes?
        self.class.generated_cattr_readers && self.class.cloader && self.class.cattr_readers.length > 0
      end

      def initialize_generated_cattr_readers
        self.generated_cattr_readers = GeneratedAttributeReaders.new
        self.extend(generated_cattr_readers)
        define_cattributes
      end

      def define_cattributes
        readers = masterman.cattr_readers

        generated_cattr_readers.module_eval do
          readers.each do |reader|
            define_method reader do
              masterman.class_loader.all[reader.to_s]
            end
          end
        end
      end
    end

    class GeneratedAttributeReaders < Module; end

    def initialize(attributes = {})
      initialize_generated_attr_readers unless self.class.generated_attr_readers

      attributes.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end
    end

    def ==(other)
      other.is_a?(self.class) &&
        !other[self.class.masterman.primary_key].nil? &&
        other.attributes == attributes
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

    def initialize_generated_attr_readers
      self.class.generated_attr_readers = GeneratedAttributeReaders.new
      self.class.include(generated_attr_readers)
      define_attributes
      define_reflections
    end

    def define_reflections
      self.class.masterman.reflections.each do |name, _|
        generated_attr_readers.module_eval do
          define_method(name) do
            self.class.masterman.association(name, self).reader
          end
        end
      end
    end

    def define_attributes
      readers = self.class.masterman.attr_readers

      generated_attr_readers.module_eval do
        attr_reader *readers
      end
    end
  end
end
