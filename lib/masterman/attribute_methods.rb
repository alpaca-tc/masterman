module Masterman
  module AttributeMethods
    def attributes
      masterman.attr_readers.each_with_object({}) do |attr, memo|
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

    def ==(other)
      other.is_a?(self.class) &&
        !other[self.class.masterman.primary_key].nil? &&
        other.attributes == attributes
    end
  end
end
