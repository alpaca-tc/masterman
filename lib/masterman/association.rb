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
      when :has_one
      end
    end
  end
end
