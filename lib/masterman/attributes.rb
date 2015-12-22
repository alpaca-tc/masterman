require 'active_support/core_ext/module/attribute_accessors'

module Masterman
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :attribute_methods
      self.attribute_methods = []
    end

    def attribute_accessor(*attrs)
      self.attribute_methods += attrs
    end
  end
end
