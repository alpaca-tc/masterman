require 'active_model'

module Masterman
  module Base
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Model
      include Core
      include Attributes
      include Associations
      include Collection
      include Reflection
      include Mountable
    end
  end
end
