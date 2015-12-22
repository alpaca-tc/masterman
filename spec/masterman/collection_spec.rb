require 'spec_helper'

RSpec.describe Masterman::Collection do
  let(:klass) do
    Class.new do
      include Masterman

      masterman.mount_options = {
        file: File.expand_path('../../fixtures/masterdata.yml', __FILE__),
        loader: :yaml
      }

      masterman.attribute_accessor :id, :name
    end
  end

  describe '.find' do
    subject { klass.find(id) }

    context 'if record is exist' do
      let(:id) { 1 }

      it 'finds by id' do
        is_expected.to be_a(klass.masterman.model_class)
      end
    end

    context 'if record is not exist' do
      let(:id) { 10 }

      it 'raise not found error' do
        expect { subject }.to raise_error(Masterman::RecordNotFound)
      end
    end
  end

  describe '.find_by' do
    subject { klass.find_by(id: id) }

    context 'if record is exist' do
      let(:id) { 1 }

      it 'finds by id' do
        is_expected.to be_a(klass.masterman.model_class)
      end
    end

    context 'if record is not exist' do
      let(:id) { 10 }
      it { is_expected.to be_nil }
    end
  end
end
