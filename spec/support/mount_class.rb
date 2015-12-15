module RSpecSupport
  module MountClass
    def mount_class(&block)
      Class.new do
        include Masterman

        define_masterman do
          mount_data file: File.expand_path('../../fixtures/masterdata.yml', __FILE__), loader: :yaml
          attribute_accessor :id, :name
        end
      end
    end

    RSpec.configuration.include(self)
  end
end
