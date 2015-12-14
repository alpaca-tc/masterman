require 'yaml'

module Masterman
  module Loader
    module Yaml
      def self.read(fname)
        ::YAML.load_file(fname)
      end
    end
  end
end
