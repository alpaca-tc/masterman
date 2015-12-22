require 'masterman/mountable'
require 'masterman/reflection'
require 'masterman/association'
require 'masterman/collection'
require 'masterman/attributes'

module Masterman
  module Core
    extend ActiveSupport::Concern

    included do
      class_attribute :generated_attribute_methods
    end

    class GeneratedAttributeMethods < Module
      # include AttributeMethods
      # include Collection
    end

    def initialize(attributes = {})
      initialize_generated_modules unless self.class.generated_attribute_methods

      attributes.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end

      super unless method(__method__).super_method.arity.zero?
    end

    private

    def initialize_generated_modules
      self.class.generated_attribute_methods = GeneratedAttributeMethods.new
      self.class.include(generated_attribute_methods)
      define_attributes
      define_reflections
    end

    def define_reflections
      masterman.reflections.each do |name, _|
        generated_attribute_methods.module_eval do
          define_method(name) do
            self.class.masterman.association(name, self).reader
          end
        end
      end
    end

    def define_attributes
      attribute_methods = masterman.attribute_methods

      generated_attribute_methods.module_eval do
        attr_accessor *attribute_methods
      end
    end

    def masterman
      self.class.masterman
    end
  end
end
