require 'masterman/mountable'
require 'masterman/reflection'
require 'masterman/association'
require 'masterman/collection'
require 'masterman/attributes'

module Masterman
  module Core
    extend ActiveSupport::Concern

    included do
      include Attributes
      include Collection
      include Reflection
      include Mountable
    end

    class GeneratedAttributeMethods < Module; end

    def initialize(attributes = {})
      super(attributes)

      unless @attribute_methods_generated
        initialize_generated_modules
        define_reflections
        @attribute_methods_generated = true
      end
    end

    private

    def initialize_generated_modules
      @generated_attribute_methods = GeneratedAttributeMethods.new
      @attribute_methods_generated = false
      self.class.include @generated_attribute_methods
    end

    def define_reflections
      self.class._reflections.each do |name, reflection|
        @generated_attribute_methods.module_eval do
          define_method name do
            binding.pry;
          end
        end
      end
    end
  end
end
