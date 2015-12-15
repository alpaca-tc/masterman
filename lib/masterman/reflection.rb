module Masterman
  module Reflection
    extend ActiveSupport::Concern

    included do
      cattr_accessor :_reflections
      self._reflections = {}
    end

    def self.add_reflection(masterman, name, reflection)
      masterman._reflections = masterman._reflections.merge(name.to_s => reflection)
    end

    class Macro
      attr_reader :name, :scope, :options, :model_class

      def initialize(name, scope, options, model_class)
        @name = name
        @scope = scope
        @options = options
        @model_class = model_class
      end

      def foreign_key
        (options[:foreign_key] || "#{name.to_s}_id").to_s
      end

      def macro
        @options[:macro]
      end

      def build_association(instance, reflection)
        Masterman::Association.new(instance, reflection)
      end

      def klass
        @klass ||= compute_class(class_name)
      end

      private

      def class_name
        name.to_s.camelize
      end

      def compute_class(name)
        class_name = name.to_s
        class_name = class_name.singularize if collection?
        class_name.camelize.constantize
      end

      def collection?
        macro == :has_many
      end
    end
  end
end
