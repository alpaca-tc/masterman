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
        @records ||= if @_mount_options[:file]
                       load_file(@_mount_options[:file], @_mount_options[:loader])
                     elsif @_mount_options[:direct]
                       optimize_records(@_mount_options[:direct])
                     end
      end

      def load_file(fname, loader_name)
        loader = Loader.for(loader_name)
        optimize_records(loader.read(fname))
      end

      def optimize_records(records)
        records.each_with_object({}) do |attributes, memo|
          record = new(attributes)
          memo[record[primary_key]] = record
        end
      end
    end
  end
end
