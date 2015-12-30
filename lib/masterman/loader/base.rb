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

      private

      def loader_options
        @options.fetch(:loader_options, {})
      end
    end
  end
end
