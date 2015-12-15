module Masterman
  module Reflection
    class Macro
      attr_reader :name, :scope, :options, :model_class

      def initialize(name, scope, options, model_class)
        @name = name
        @scope = scope
        @options = options
        @model_class = model_class
      end

      def foreign_key
        options.fetch(:foregin_key, "#{name.to_s}_id")
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
        name.constantize
      end
    end
  end
end
