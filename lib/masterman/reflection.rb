module Masterman
  module Reflection
    extend ActiveSupport::Concern

    def self.build(macro, name, scope, options, model_class)
      case macro
      when :belongs_to
        BelongsToReflection.new(name, scope, options, model_class)
      when :has_one
        reflection = HasOne.new(name, scope, options, model_class)

        if options[:through]
          ThroughReflection.new(reflection)
        else
          reflection
        end
      when :has_many
        reflection = HasManyReflection.new(name, scope, options, model_class)

        if options[:through]
          ThroughReflection.new(reflection)
        else
          reflection
        end
      else
        raise NotImplementedError, "#{macro} is not supported"
      end
    end

    def self.add_reflection(masterman, name, reflection)
      masterman._reflections = masterman._reflections.merge(name.to_s => reflection)
    end

    def _reflections
      @_reflections ||= {}
    end

    def _reflections=(val)
      @_reflections = val
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

    class BelongsToReflection < Macro
      def macro
        :belongs_to
      end

      private

      def collection?
        false
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

    class HasOneReflection < Macro
      def macro
        :has_one
      end

      private

      def collection?
        false
      end
    end

    class ThroughReflection
      extend Forwardable
      delegate [:collection, :macro, :options, :scope, :klass, :foreign_key, :through_reflection, :build_association] => @delegate_reflection

      def initialize(delegate_reflection)
        @delegate_reflection = delegate_reflection
      end
    end
  end
end
