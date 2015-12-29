require 'spec_helper'

RSpec.describe Masterman::Loader do
  describe '.build' do
    subject { described_class.build(options) }

    shared_examples_for 'a loader' do
      describe 'implemented loader methods' do
        it { is_expected.to respond_to(:find) }
        it { is_expected.to respond_to(:all) }
      end

      describe 'load file' do
        it 'loads file' do
          subject.all.each do |attributes|
            expect(attributes).to be_key('id').and be_key('name')
          end
        end
      end
    end

    context 'given :json' do
      let(:options) do
        { path: File.expand_path('../../fixtures/masterdata.json', __FILE__), loader: :json }
      end

      it { is_expected.to be_a(described_class::Json) }

      it_behaves_like 'a loader'
    end

    context 'given :yaml' do
      let(:options) do
        {
          path: File.expand_path('../../fixtures/masterdata.yml', __FILE__),
          loader: :yaml
        }
      end

      it { is_expected.to be_a(described_class::Yaml) }

      it_behaves_like 'a loader'
    end

    context 'given :csv' do
      let(:options) do
        {
          path: File.expand_path('../../fixtures/masterdata.csv', __FILE__),
          loader: :csv
        }
      end

      it { is_expected.to be_a(described_class::Csv) }

      it_behaves_like 'a loader'
    end

    context 'given :direct' do
      let(:options) do
        { direct: [] }
      end

      it { is_expected.to be_a(described_class::Direct) }

      it_behaves_like 'a loader'
    end
  end
end
