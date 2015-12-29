require 'json'

module Masterman
  module Loader
    class Json < Base
      self.extensions = [:json]

      def all
        ::JSON.parse(File.read(options[:path]))
      end

      Loader.register_loader(self)
    end
  end
end
