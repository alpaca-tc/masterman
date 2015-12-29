require 'csv'

module Masterman
  module Loader
    class Csv < Base
      self.extensions = [:csv]

      def all
        CSV.read(options[:path], headers: true)
      end

      Loader.register_loader(self)
    end
  end
end
