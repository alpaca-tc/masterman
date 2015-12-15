module Masterman
  module AttributeMethods
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
