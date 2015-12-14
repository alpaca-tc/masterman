require 'json'

module Masterman
  module Loader
    module Json
      def self.read(fname)
        ::JSON.parse(File.read(fname))
      end
    end
  end
end
