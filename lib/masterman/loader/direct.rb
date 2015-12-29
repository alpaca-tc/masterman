require 'csv'

module Masterman
  module Loader
    class Direct < Base
      self.extensions = []

      def all
        options[:direct]
      end

      Loader.register_loader(self)
    end
  end
end
