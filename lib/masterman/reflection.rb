module Masterman
  module Reflection
    autoload :Macro, 'masterman/reflection/macro'
    autoload :HasOneReflection, 'masterman/reflection/macro'
    autoload :HasManyReflection, 'masterman/reflection/macro'
    autoload :BelongsToReflection, 'masterman/reflection/macro'
    autoload :ThroughReflection, 'masterman/reflection/macro'

    def self.build(macro, name, scope, options, model_class)
      case macro
      when :belongs_to
        return BelongsToReflection.new(name, scope, options, model_class)
      when :has_one
        reflection = HasOne.new(name, scope, options, model_class)
      when :has_many
        reflection = HasManyReflection.new(name, scope, options, model_class)
      else
        raise NotImplementedError, "#{macro} is not supported"
      end

      if options[:through]
        ThroughReflection.new(reflection)
      else
        reflection
      end
    end

    def self.add_reflection(masterman_base, name, reflection)
      masterman_base._reflections.merge!(name.to_s => reflection)
    end

    def _reflections
      @_reflections ||= {}
    end

    def _reflections=(val)
      @_reflections = val
    end
  end
end
