require 'csv'

module Masterman
  module Loader
    class Csv < Base
      self.extensions = [:csv]

      private

      def find_all
        CSV.read(options[:path], loader_options)
      end

      def default_loader_options
        { headers: true }
      end

      Loader.register_loader(self)
    end
  end
end
