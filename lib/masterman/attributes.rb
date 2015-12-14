module Masterman
  module Attributes
    extend ActiveSupport::Concern

    included do
      cattr_accessor :attribute_methods
      self.attribute_methods = []
    end

    class_methods do
      def attribute_accessor(*attrs)
        self.attribute_methods += attrs
        attr_accessor(*attrs)
      end
    end

    def attributes
      self.class.attribute_methods.each_with_object({}) do |attr, memo|
        value = public_send(attr)
        memo[attr.to_s] = value if value
      end
    end

    def assign_attributes(attributes)
      attributes.each do |key, value|
        public_send("#{key}=", value)
      end
    end

    def [](key)
      public_send(key)
    end

    def []=(key, value)
      public_send("#{key}=", value)
    end
  end
end
