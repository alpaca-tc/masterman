require 'spec_helper'

RSpec.describe Masterman::Loader do
  describe '.for' do
    subject { described_class.for(name) }

    shared_examples_for 'a loader' do
      describe 'implemented loader methods' do
        it { is_expected.to respond_to(:read) }
      end

      describe 'load file' do
        it 'loads file' do
          subject.read(path).each do |attributes|
            expect(attributes).to be_key('id').and be_key('name')
          end
        end
      end
    end

    context 'given :json' do
      let(:name) { :json }
      let(:path) { File.expand_path('../../fixtures/masterdata.json', __FILE__) }
      it { is_expected.to eq(described_class::Json) }

      it_behaves_like 'a loader'
    end

    context 'given :yaml' do
      let(:name) { :yaml }
      let(:path) { File.expand_path('../../fixtures/masterdata.yml', __FILE__) }
      it { is_expected.to eq(described_class::Yaml) }

      it_behaves_like 'a loader'
    end

    context 'given :csv' do
      let(:name) { :csv }
      let(:path) { File.expand_path('../../fixtures/masterdata.csv', __FILE__) }
      it { is_expected.to eq(described_class::Csv) }

      it_behaves_like 'a loader'
    end
  end
end
