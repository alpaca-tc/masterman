module RSpecSupport
  module MountClass
    def mount_class(&block)
      Class.new do
        include ActiveModel::Model
        include Masterman::Core
        mount_data file: File.expand_path('../../fixtures/masterdata.yml', __FILE__), loader: :yaml
        attribute_accessor :id, :name
        self.class_eval(&block) if block_given?
      end
    end

    RSpec.configuration.include(self)
  end
end
