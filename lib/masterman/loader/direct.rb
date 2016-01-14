require 'csv'

module Masterman
  module Loader
    class Direct < Base
      self.extensions = []

      private

      def find_all
        options[:direct]
      end

      Loader.register_loader(self)
    end
  end
end
