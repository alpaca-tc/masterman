require 'csv'

module Masterman
  module Loader
    module Csv
      def self.read(fname)
        CSV.read(fname, headers: true)
      end
    end
  end
end
