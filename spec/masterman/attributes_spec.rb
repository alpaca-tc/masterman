require 'spec_helper'

RSpec.describe Masterman::Attributes do
  describe '.attribute_accessor' do
    let(:klass) do
      Class.new do
        include Masterman
        masterman.attribute_accessor :id, :name
        masterman.mount_options = { direct: [{ id: 1, name: 'name' }] }
      end
    end

    it 'defines accessor' do
      records = klass.masterman.all.values
      expect(records.first.name).to eq('name')
    end
  end
end
