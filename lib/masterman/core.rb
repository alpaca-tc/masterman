require 'masterman/mountable'
require 'masterman/reflection'
require 'masterman/association'
require 'masterman/collection'
require 'masterman/attributes'

module Masterman
  module Core
    extend ActiveSupport::Concern

    included do
      class_attribute :generated_attr_readers
    end

    class GeneratedAttributeReaders < Module; end

    def initialize(attributes = {})
      initialize_generated_modules unless self.class.generated_attr_readers

      attributes.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end
    end

    private

    def initialize_generated_modules
      self.class.generated_attr_readers = GeneratedAttributeReaders.new
      self.class.include(generated_attr_readers)
      define_attributes
      define_reflections
    end

    def define_reflections
      masterman.reflections.each do |name, _|
        generated_attr_readers.module_eval do
          define_method(name) do
            self.class.masterman.association(name, self).reader
          end
        end
      end
    end

    def define_attributes
      readers = masterman.attr_readers

      generated_attr_readers.module_eval do
        attr_reader *readers
      end
    end

    def masterman
      self.class.masterman
    end
  end
end
