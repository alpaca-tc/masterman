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

    it 'defines reader' do
      records = klass.masterman.all.values
      expect(records.first.name).to eq('name')
    end
  end
end
