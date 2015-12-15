require 'spec_helper'

RSpec.describe Masterman::Collection do
  describe '.find' do
    subject { mounted.find(id) }
    let(:mounted) { mount_class }

    context 'if record is exist' do
      let(:id) { 1 }

      it 'finds by id' do
        is_expected.to be_a(mounted.masterman.model_class)
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
