module Masterman
  module Mountable
    extend ActiveSupport::Concern

    def primary_key
      @primary_key || :id
    end

    def primary_key=(val)
      @primary_key = val
    end

    def mount_data(options)
      @_mount_options = options
    end

    # DO NOT LOAD LARGE FILE
    def load_records
      # XXX: Should I remove cache from memory?
      @records ||= if _mount_options[:file]
                     load_file(_mount_options[:file], _mount_options[:loader])
                   elsif _mount_options[:direct]
                     to_records(_mount_options[:direct])
                   else
                     nil
                   end
    end

    private

    def _mount_options
      @_mount_options || {}
    end

    def load_file(fname, loader_name)
      loader = Loader.for(loader_name)
      to_records(loader.read(fname))
    end

    def to_records(records)
      records.each_with_object({}) do |attributes, memo|
        record = model_class.new(attributes)
        memo[record[primary_key]] = record
      end
    end
  end
end
