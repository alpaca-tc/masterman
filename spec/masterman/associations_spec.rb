require 'masterman_spec'

RSpec.describe Masterman::Attributes do
  describe '.attribute_accessor' do
    let(:base) do
      Masterman::Base
    end

    let(:users) do
      Class.new(base) do
        mount_data direct: [{ id: 1, name: 'user' }]
        attribute_accessor :id, :name
      end
    end

    let(:items) do
      Class.new(base) do
        mount_data direct: [{ id: 1, name: 'item', user_id: 1 }]
        attribute_accessor :id, :name
      end
    end

    it 'defines accessor' do
      expect(users.first.name).to be_a(String)
    end
  end
end
