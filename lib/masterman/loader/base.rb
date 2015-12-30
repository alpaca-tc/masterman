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
        default_loader_options.merge(@options.fetch(:loader_options, {}))
      end

      def default_loader_options
        {}
      end
    end
  end
end
