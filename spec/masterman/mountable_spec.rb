require 'spec_helper'

RSpec.describe Masterman::Mountable do
  describe 'ClassMethods' do
    describe '.primary_id=' do
      let(:mounted) do
        mount_class do
          self.primary_key = :custom_id
          attribute_accessor :custom_id
        end
      end

      it 'set primary_id' do
        expect(mounted.masterman.primary_key).to eq(:custom_id)
      end
    end

    describe '.mount_data' do
      describe 'directly' do
        let(:mounted) do
          mount_class do
            mount_data direct: [{ id: 1 }]
            attribute_accessor :id
          end
        end

        it 'mount data directly' do
          expect(mounted.first).to be_present
        end
      end
    end
  end
end
