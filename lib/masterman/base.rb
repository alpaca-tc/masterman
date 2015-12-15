require 'active_model'

module Masterman
  class Base
    include ActiveModel::Model
    include Core
    include Attributes
    include Collection
    include Reflection
    include Mountable
  end
end
