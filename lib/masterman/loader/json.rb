require 'json'

module Masterman
  module Loader
    module Json
      def self.read(fname, options = {})
        ::JSON.load(fname, options)
      end
    end
  end
end
