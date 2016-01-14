require 'spec_helper'

RSpec.describe Masterman::Loader do
  describe '.build' do
    subject { described_class.build(options) }

    shared_examples_for 'a loader' do
      describe 'implemented loader methods' do
        it { is_expected.to respond_to(:find) }
        it { is_expected.to respond_to(:all) }

        describe 'cacheable' do
          let(:options) { super().merge(cache: true) }

          it 'returns cached static data' do
            expect(subject).to receive(:find_all).once.and_return([])
            subject.all
            subject.all
          end
        end
      end

      describe 'load file' do
        it 'loads file' do
          subject.all.each do |attributes|
            expect(attributes).to be_key('id').and be_key('name')
          end
        end
      end

      describe 'without :loader option' do
        it 'returns loader' do
          original = described_class.build(options)
          without_loader = described_class.build(options.except(:loader))
          expect(original).to be_a(described_class::Base)
          expect(original.class).to eq(without_loader.class)
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
