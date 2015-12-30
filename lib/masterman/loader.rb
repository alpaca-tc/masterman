require 'active_support/core_ext/string/inflections'

module Masterman
  module Loader
    class << self
      def register_loader(loader)
        loaders.push(loader)
      end

      def build(options = {})
        loader = detect_loader(options)
        loader.new(options)
      end

      private

      def loaders
        @loaders ||= []
      end

      def detect_loader(options)
        if options[:loader].is_a?(Class)
          # Given loader class as option
          options[:loader]
        elsif options.key?(:direct)
          Loader::Direct
        elsif !options.key?(:loader) && options.key?(:path)
          # Detect loader from path path if Missing loader options
          extname = File.extname(options[:path]).sub(/^\./, '').to_sym
          loaders.find { |loader| loader.extensions.include?(extname) }
        else
          # From string or symbol
          const_get(options[:loader].to_s.classify)
        end
      end
    end

    require 'masterman/loader/base'
    require 'masterman/loader/yaml'
    require 'masterman/loader/json'
    require 'masterman/loader/csv'
    require 'masterman/loader/direct'
  end
end
