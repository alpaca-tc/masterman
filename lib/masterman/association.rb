module Masterman
  class Association
    attr_reader :macro

    def initialize(model, name, macro:)
      @model = model
      @name = name
      @macro = macro
    end
  end
end
