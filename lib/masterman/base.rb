require 'active_model'

module Masterman
  class Base
    # include Attributes
    include Associations
    include Reflection
    # include Mountable
  end
end
