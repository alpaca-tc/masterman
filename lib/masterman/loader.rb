require 'active_support/core_ext/string/inflections'

module Masterman
  module Loader
    autoload :Yaml, 'masterman/loader/yaml'
    autoload :Json, 'masterman/loader/json'
    autoload :Csv, 'masterman/loader/csv'

    def self.for(name)
      if name.is_a?(Module)
        name
      else
        const_get(name.to_s.classify)
      end
    end
  end
end
