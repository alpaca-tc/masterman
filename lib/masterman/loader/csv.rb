require 'csv'

module Masterman
  module Loader
    module Csv
      def self.read(fname, options = {})
        CSV.read(fname, options.merge(headers: false))
      end
    end
  end
end
