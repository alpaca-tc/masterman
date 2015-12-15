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
        model_class = collection_target.model_class.model_class
        model_class.select { |record| record[collection_target.foreign_key] == model[model.class.masterman.primary_key] }
      when :has_one
        model_class = collection_target.model_class.model_class
        model_class.find(model[model.class.masterman.primary_key])
      end
    end

    private

    def collection_target
      reflection.klass.masterman._reflections[model.name]
    end
  end
end
