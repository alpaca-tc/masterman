module Masterman
  class Base
    include Attributes
    include Associations
    include Reflection
    include Mountable

    attr_reader :model_class

    def initialize(model_class)
      @model_class = model_class
    end
  end
end
