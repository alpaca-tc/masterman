require 'active_support/core_ext/module/attribute_accessors'

module Masterman
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :attr_readers
      self.attr_readers = []
    end

    def attr_reader(*attrs)
      self.attr_readers += attrs
    end
  end
end
