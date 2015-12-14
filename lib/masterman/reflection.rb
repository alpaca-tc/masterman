module Masterman
  module Reflection
    extend ActiveSupport::Concern

    included do
      cattr_accessor :_reflections
      self._reflections = []
    end

    class_methods do
      def belongs_to(name)
        add_reflection self, name, Association.new(self, name, macro: :belongs_to)
      end

      def has_many(name)
        add_reflection self, name, Association.new(self, name, macro: :has_many)
      end

      def has_one(name)
        add_reflection self, name, Association.new(self, name, macro: :has_one)
      end

      private

      def add_reflection(model, name, reflection)
        model._reflections = model.merge(name.to_s => reflection)
      end
    end
  end
end
