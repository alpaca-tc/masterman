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
      super unless method(__method__).super_method.arity.zero?
      initialize_generated_modules unless self.class.generated_attribute_methods
    end

    private

    def initialize_generated_modules
      self.class.generated_attribute_methods = GeneratedAttributeMethods.new
      self.class.include(generated_attribute_methods)
      define_reflections
    end

    def define_reflections
      masterman.reflections.each do |name, _|
        self.class.generated_attribute_methods.module_eval do
          define_method(name) do
            self.class.masterman.association(name, self).reader
          end
        end
      end
    end

    def masterman
      self.class.masterman
    end
  end
end
