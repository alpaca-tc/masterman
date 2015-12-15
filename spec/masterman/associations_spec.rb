require 'masterman_spec'

RSpec.describe Masterman::Attributes do
  describe '.attribute_accessor' do
    before do
      class User
        include Masterman::Base
        mount_data direct: [{ id: 1, name: 'user' }]
        attribute_accessor :id, :name
      end

      class Item
        include Masterman::Base
        mount_data direct: [{ id: 1, name: 'item', user_id: 1 }]
        attribute_accessor :id, :name, :user_id

        belongs_to :user
      end
    end

    after do
      Object.send(:remove_const, :User)
      Object.send(:remove_const, :Item)
    end

    it 'defines accessor' do
      expect(User.first.name).to be_a(String)
      expect(Item.first.user).to eq(User.first)
    end
  end
end
