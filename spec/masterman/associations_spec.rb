require 'spec_helper'

RSpec.describe Masterman::Associations do
  before do
    class User
      include Masterman

      masterman do
        self.mount_options = { direct: [{ id: 1, name: 'user' }] }
        attribute_accessor :id, :name
        has_one :user_secret
        has_many :items
        has_many :variations, through: :items
        has_many :attachments, through: :variations
      end
    end

    class Item
      include Masterman

      masterman do
        self.mount_options = { direct: [{ id: 1, name: 'item', user_id: 1 }] }
        attribute_accessor :id, :name, :user_id
        belongs_to :user
        has_many :variations
      end
    end

    class Variation
      include Masterman

      masterman do
        self.mount_options = { direct: [{ id: 1, name: 'Variation', item_id: 1 }] }
        attribute_accessor :id, :name, :item_id
        belongs_to :item
        has_one :user, through: :item
        has_many :attachments
      end
    end

    class Attachment
      include Masterman

      masterman do
        self.mount_options = { direct: [{ id: 1, name: 'Attachment', variation_id: 1 }] }
        attribute_accessor :id, :name, :variation_id
        belongs_to :variation
      end
    end

    class UserSecret
      include Masterman

      masterman do
        self.mount_options = { direct: [{ id: 1, name: 'user_secret', user_id: 1 }] }
        attribute_accessor :id, :name, :user_id
        belongs_to :user
      end
    end
  end

  after do
    Object.send(:remove_const, :User)
    Object.send(:remove_const, :Item)
    Object.send(:remove_const, :Variation)
    Object.send(:remove_const, :Attachment)
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

  describe '.has_many with through' do
    it 'have_many through association' do
      expect(User.first.variations).to eq([Variation.first])
      expect(User.first.attachments).to eq([Attachment.first])
    end
  end

  describe '.has_one with through' do
    it 'have_one through association' do
      expect(Variation.first.user).to eq(User.first)
    end
  end
end
