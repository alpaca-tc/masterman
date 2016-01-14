require 'spec_helper'

RSpec.describe Masterman::Attributes do
  describe '.attr_reader' do
    let(:klass) do
      Class.new do
        include Masterman
        masterman do
          mount(direct: [{ id: 1, name: 'name' }])
          attr_reader :id, :name
        end
      end
    end

    it 'defines attribute reader' do
      record = klass.find(1)
      expect(record.name).to eq('name')
    end
  end

  describe '.cattr_reader' do
    let(:klass) do
      Class.new do
        include Masterman
        masterman do
          class_mount(direct: { name: 'name' })
          cattr_reader :name
          mount_class_attributes!
        end
      end
    end

    it 'defines class attribute reader' do
      expect(klass.name).to eq('name')
    end
  end
end
