require 'active_model'

module Masterman
  class Base
    include ActiveModel::Model
    include Core
    include Attributes
    include Associations
    include Collection
    include Reflection
    include Mountable

    def initialize(model_class)
      @model_class = model_class
    end
  end
end
