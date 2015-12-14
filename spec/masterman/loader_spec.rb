require 'masterman_spec'

RSpec.describe Masterman::Loader do
  describe '.for' do
    subject { described_class.for(name) }

    shared_examples_for 'a loader' do
      describe 'implemented loader methods' do
        it { is_expected.to respond_to(:read) }
      end
    end

    context 'given :json' do
      let(:name) { :json }
      it { is_expected.to eq(described_class::Json) }
      it_behaves_like 'a loader'
    end

    context 'given :yaml' do
      let(:name) { :yaml }
      it { is_expected.to eq(described_class::Yaml) }
      it_behaves_like 'a loader'
    end

    context 'given :csv' do
      let(:name) { :csv }
      it { is_expected.to eq(described_class::Csv) }
      it_behaves_like 'a loader'
    end
  end
end
