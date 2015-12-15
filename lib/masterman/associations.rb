module Masterman
  module Associations
    extend ActiveSupport::Concern

    class_methods do
      def belongs_to(name, scope = nil, options = {})
        build_reflection_and_add(name, scope, options, :belongs_to)
      end

      def has_many(name, scope = nil, options = {})
        build_reflection_and_add(name, scope, options, :has_many)
      end

      def has_one(name, scope = nil, options = {})
        build_reflection_and_add(name, scope, options, :has_one)
      end

      private

      def build_reflection_and_add(name, scope, options, macro)
        reflection = Reflection::Macro.new(name, scope, options.merge(macro: macro), self)
        Reflection.add_reflection self, name, reflection
      end
    end

    def association(name)
      association = association_instance_get(name)

      if association.nil?
        reflection = self.class._reflections[name]
        association = reflection.build_association(self, reflection)
        association_instance_set(name, association)
      end

      association
    end

    private

    def association_instance_get(name)
      association_instance_cache[name]
    end

    def association_instance_set(name, value)
      association_instance_cache[name] = value
    end

    def association_instance_cache
      @association_instance_cache ||= {}
    end
  end
end
