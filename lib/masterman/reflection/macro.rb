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
        (options[:foreign_key] || "#{name.to_s}_id").to_s
      end

      def macro
        raise NotImplementedError, 'macro is not defined'
      end

      def build_association(instance, reflection)
        Masterman::Association.new(instance, reflection)
      end

      def klass
        @klass ||= compute_class(class_name)
      end

      def through_reflection
        if options[:through]
          model_class._reflections[options[:through].to_s]
        end
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
        raise NotImplementedError, 'collection? is not defined'
      end
    end

    class SinglurReflection < Macro
      private

      def collection?
        false
      end
    end

    class BelongsToReflection < SinglurReflection
      def macro
        :belongs_to
      end
    end

    class HasOneReflection < SinglurReflection
      def macro
        :has_one
      end
    end

    class HasManyReflection < Macro
      def macro
        :has_many
      end

      private

      def collection?
        true
      end
    end

    class ThroughReflection
      extend Forwardable

      delegate %i(
        collection macro options scope klass foreign_key
        through_reflection build_association
      ) => :@delegate_reflection

      def initialize(delegate_reflection)
        @delegate_reflection = delegate_reflection
      end
    end
  end
end
