module Masterman
  module Loader
    class Base
      attr_reader :options
      class_attribute :extensions
      self.extensions = []

      def initialize(options = {})
        @options = options
      end

      def find(*)
        raise NotImplementedError, 'not implemented yet'
      end

      def all(*)
        raise NotImplementedError, 'not implemented yet'
      end
    end
  end
end
