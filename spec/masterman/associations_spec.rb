require 'spec_helper'

RSpec.describe Masterman::Associations do
  before do
    class User
      include Masterman

      configure_masterman do
        mount_data direct: [{ id: 1, name: 'user' }]
        attribute_accessor :id, :name
        has_one :user_secret
        has_many :items
      end
    end

    class Item
      include Masterman

      configure_masterman do
        mount_data direct: [{ id: 1, name: 'item', user_id: 1 }]
        attribute_accessor :id, :name, :user_id
        belongs_to :user
      end
    end

    class UserSecret
      include Masterman

      configure_masterman do
        mount_data direct: [{ id: 1, name: 'user_secret', user_id: 1 }]
        attribute_accessor :id, :name, :user_id
        belongs_to :user
      end
    end
  end

  after do
    Object.send(:remove_const, :User)
    Object.send(:remove_const, :Item)
  end

  describe '.belongs_to' do
    it 'belongs to item' do
      expect(Item.first.user).to eq(User.first)
    end
  end

  describe '.has_many' do
    it 'has many items' do
      expect(User.first.items).to eq([Item.first])
    end
  end

  describe '.has_one' do
    it 'has one to user_secret' do
      expect(User.first.user_secret).to eq(UserSecret.first)
    end
  end

  # describe '.has_many with through' do
  #   before do
  #     class User
  #       include Masterman
  #
  #       configure_masterman do
  #         mount_data direct: [{ id: 1, name: 'user' }]
  #         attribute_accessor :id, :name
  #         has_many :items
  #         has_many :variations, through: :items
  #       end
  #     end
  #
  #     class Item
  #       include Masterman
  #
  #       configure_masterman do
  #         mount_data direct: [{ id: 1, name: 'item', user_id: 1 }]
  #         attribute_accessor :id, :name, :user_id
  #         belongs_to :user
  #       end
  #     end
  #
  #     class Variation
  #       include Masterman
  #
  #       configure_masterman do
  #         mount_data direct: [{ id: 1, name: 'Variation', item_id: 1 }]
  #         attribute_accessor :id, :name, :item_id
  #         belongs_to :item
  #         has_one :user, through: :item
  #       end
  #     end
  #   end
  #
  #   after do
  #     Object.send(:remove_const, :User)
  #     Object.send(:remove_const, :Item)
  #   end
  #
  #   it 'defines belongs association' do
  #     expect(User.first.items).to eq([Item.first])
  #     binding.pry;
  #     # expect(User.first.variations).to eq([Variation.first])
  #     # expect(Variation.first.user).to eq(User.first)
  #   end
  # end

  describe '.has_one' do
    before do
      class User
        include Masterman

        configure_masterman do
          mount_data direct: [{ id: 1, name: 'user' }]
          attribute_accessor :id, :name
          has_one :item
        end
      end

      class Item
        include Masterman

        configure_masterman do
          mount_data direct: [{ id: 1, name: 'item', user_id: 1 }]
          attribute_accessor :id, :name, :user_id
          belongs_to :user
        end
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
