require 'spec_helper'

RSpec.describe Masterman::Attributes do
  describe '.attribute_accessor' do
    let(:mounted) do
      mount_class do
        attribute_accessor :name
      end
    end

    it 'defines accessor' do
      expect(mounted.first.name).to be_a(String)
    end
  end
end
