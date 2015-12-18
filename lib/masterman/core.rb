require 'masterman/mountable'
require 'masterman/reflection'
require 'masterman/association'
require 'masterman/collection'
require 'masterman/attributes'

module Masterman
  module Core
    extend ActiveSupport::Concern

    included do
      cattr_accessor :generated_attribute_methods
    end

    class GeneratedAttributeMethods < Module; end

    def initialize(attributes = {})
      super(attributes)
      initialize_generated_modules unless self.class.generated_attribute_methods
    end

    private

    def initialize_generated_modules
      self.class.generated_attribute_methods = GeneratedAttributeMethods.new
      self.class.include(generated_attribute_methods)
      define_reflections
    end

    def define_reflections
      self.class.masterman._reflections.each do |name, _|
        self.class.generated_attribute_methods.module_eval do
          define_method(name) { self.class.masterman.association(name, self).reader }
        end
      end
    end
  end
end
