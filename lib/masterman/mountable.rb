module Masterman
  module Mountable
    attr_accessor :primary_key, :mount_options

    def primary_key
      @primary_key || :id
    end

    def all
      to_instances(load_records)
    end

    private

    def load_records
      if !mount_options
        raise MastermanError, 'not defined .mount with options. Please call .mount on this class'
      elsif mount_options[:file]
        load_file(mount_options[:file], mount_options[:loader])
      elsif mount_options[:direct]
        load_direct(mount_options[:direct])
      else
        nil
      end
    end

    def load_file(fname, loader_name)
      Loader.for(loader_name).read(fname)
    end

    def load_direct(records)
      if records.respond_to?(:each)
        records
      else
        raise MastermanError, 'undefined method `each` for mount_options[:direct]'
      end
    end

    def to_instances(records)
      records.each_with_object({}) do |attributes, memo|
        record = model_class.new(attributes)
        memo[record[primary_key]] = record
      end
    end
  end
end
