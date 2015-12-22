module Masterman
  class Association
    attr_reader :model, :reflection

    def initialize(model, reflection)
      @model = model
      @reflection = reflection
    end

    def reader
      result = read_reflection

      if result && reflection.scope
        Array.wrap(result).select do |record|
          record.instance_exec(&reflection.scope)
        end
      else
        result
      end
    end

    private

    def read_reflection
      case reflection
      when Reflection::BelongsToReflection
        reflection.klass.find(model[reflection.foreign_key])
      when Reflection::HasManyReflection
        model_class = collection_target.model_class.model_class
        model_class.select { |record| record[collection_target.foreign_key] == model[model.class.masterman.primary_key] }
      when Reflection::HasOneReflection
        model_class = collection_target.model_class.model_class
        model_class.to_a.find { |record| record[collection_target.foreign_key] == model[model.class.masterman.primary_key] }
      when Reflection::ThroughReflection
        through_reflection = self.model.class.masterman.reflections[reflection.options[:through].to_s]
        through_association = self.class.new(model, through_reflection).reader
        if reflection.collection?
          through_association.map { |association|
            self.class.new(association, reflection.delegate_reflection).reader
          }.flatten.compact
        else
          through_association[reflection.delegate_reflection.name]
        end
      end
    end

    def collection_target
      reflection.klass.masterman.reflections[model.class.name.underscore]
    end
  end
end
