require 'active_model'

module Masterman
  class Base
    include Attributes
    include Associations
    include Reflection
    include Mountable

    attr_reader :model_class, :module

    def initialize(model_class)
      @model_class = model_class
      @module = Module.new
      @model_class.include(@module)
    end

    def module_exec(&block)
      @module.module_exec(&block)
    end
  end
end
