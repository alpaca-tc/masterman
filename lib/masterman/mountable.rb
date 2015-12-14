module Masterman
  module Mountable
    extend ActiveSupport::Concern

    included do
      cattr_accessor :primary_key
      self.primary_key = :id
    end

    class_methods do
      def mount_data(options)
        @_mount_options = options
      end

      def to_a
        load_records.values
      end

      def spawn
        to_a.dup
      end

      private

      # DO NOT LOAD LARGE FILE
      def load_records
        @records ||= load_file
      end

      def load_file
        fname = @_mount_options[:from]
        loader = Loader.for(@_mount_options[:loader])

        loader.read(fname).each_with_object({}) do |attributes, memo|
          record = new(attributes)
          memo[record[primary_key]] = record
        end
      end
    end
  end
end
