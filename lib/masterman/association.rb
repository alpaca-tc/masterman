module Masterman
  class Association
    attr_reader :model, :reflection

    def initialize(model, reflection)
      @model = model
      @reflection = reflection
    end

    def reader
      case reflection.macro
      when :belongs_to
        reflection.klass.find(model[reflection.foreign_key])
      when :has_many
        target = reflection.klass._reflections[model.name]
        target.model_class.select { |record| record[target.foreign_key] == model[model.class.primary_key] }
      when :has_one
        target = reflection.klass._reflections[model.name]
        target.model_class.find(model[model.class.primary_key])
      end
    end
  end
end
