module Masterman
  module Mountable
    extend ActiveSupport::Concern

    included do
      cattr_accessor :primary_key, :_mount_options
      self.primary_key = :id
      self._mount_options = {}
    end

    class_methods do
      def mount_data(options)
        self._mount_options = options
      end

      def to_a
        load_records.values
      end

      private

      # DO NOT LOAD LARGE FILE
      def load_records
        @records ||= if _mount_options[:file]
                       load_file(_mount_options[:file], _mount_options[:loader])
                     elsif _mount_options[:direct]
                       to_records(_mount_options[:direct])
                     else
                       raise ArgumentError, ".mount_data is not defined. (#{_mount_options})"
                     end
      end

      def load_file(fname, loader_name)
        loader = Loader.for(loader_name)
        to_records(loader.read(fname))
      end
    end
  end
end
