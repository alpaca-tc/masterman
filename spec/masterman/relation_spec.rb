require 'spec_helper'

RSpec.describe Masterman::Relation do
  let(:klass) do
    Class.new do
      include Masterman

      masterman.mount(path: File.expand_path('../../fixtures/masterdata.yml', __FILE__))

      masterman.attr_reader :id, :name
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

  describe '.ids' do
    subject { klass.ids }
    it { is_expected.to be_a(Array) }
  end

  describe '.pluck' do
    subject { klass.pluck(*args) }

    context 'given one argument' do
      let(:args) { [:id] }
      it { is_expected.to be_a(Array) }
      it { expect(subject.first).to be_a(Integer) }
    end

    context 'given many arguments' do
      let(:args) { [:id, :name] }
      it { is_expected.to be_a(Array) }
      it { expect(subject.first).to be_a(Array) }
    end
  end
end
