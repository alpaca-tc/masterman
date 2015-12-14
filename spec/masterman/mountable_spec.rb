require 'masterman_spec'

RSpec.describe Masterman::Mountable do
  describe 'ClassMethods' do
    describe '.primary_id=' do
      let(:mounted) do
        mount_class do
          self.primary_key = :custom_id
        end
      end

      it 'set primary_id' do
        expect(mounted.primary_key).to eq(:custom_id)
      end
    end

    describe '.find' do
      subject { mount_class.find(id) }

      context 'if record is exist' do
        let(:id) { 1 }

        it 'finds by id' do
          is_expected.to be_a(described_class)
        end
      end

      context 'if record is not exist' do
        let(:id) { 10 }

        it 'raise not found error' do
          expect { subject }.to raise_error(Masterman::RecordNotFound)
        end
      end
    end
  end
end
