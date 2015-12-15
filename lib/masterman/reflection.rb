module Masterman
  module Reflection
    autoload :Macro, 'masterman/reflection/macro'

    extend ActiveSupport::Concern

    included do
      cattr_accessor :_reflections
      self._reflections = {}
    end

    def self.add_reflection(model, name, reflection)
      model._reflections = model._reflections.merge(name.to_s => reflection)
    end
  end
end
