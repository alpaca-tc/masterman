require 'masterman_spec'

RSpec.describe Masterman::Attributes do
  describe '.belongs_to' do
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

    it 'defines belongs association' do
      expect(User.first.name).to be_a(String)
      expect(Item.first.user).to eq(User.first)
    end
  end

  describe '.has_many' do
    before do
      class User
        include Masterman::Base
        mount_data direct: [{ id: 1, name: 'user' }]
        attribute_accessor :id, :name

        has_many :items
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

    it 'defines belongs association' do
      expect(User.first.items).to eq([Item.first])
    end
  end

  describe '.has_one' do
    before do
      class User
        include Masterman::Base
        mount_data direct: [{ id: 1, name: 'user' }]
        attribute_accessor :id, :name

        has_one :item
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

    it 'defines belongs association' do
      expect(User.first.item).to eq(Item.first)
    end
  end
end
