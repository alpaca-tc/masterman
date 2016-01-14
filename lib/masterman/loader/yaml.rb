require 'yaml'

module Masterman
  module Loader
    class Yaml < Base
      self.extensions = [:yml]

      private

      def find_all
        ::YAML.load_file(options[:path])
      end

      Loader.register_loader(self)
    end
  end
end
