require 'active_support/core_ext/module/attribute_accessors'

module Masterman
  module Attributes
    extend ActiveSupport::Concern

    included do
      class_attribute :attr_readers, :cattr_readers
      self.attr_readers = []
      self.cattr_readers = []
    end

    def attr_reader(*attrs)
      self.attr_readers += attrs
    end

    def cattr_reader(*attrs)
      self.cattr_readers += attrs
    end
  end
end
