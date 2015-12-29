require 'spec_helper'

RSpec.describe Masterman::AttributeMethods do
  let(:klass) do
    Class.new do
      include Masterman
      masterman.attr_reader :id
    end
  end

  let(:attributes) do
    { 'id' => 1 }
  end

  let(:instance) do
    klass.new(attributes)
  end

  describe '#attributes' do
    subject { instance.attributes }

    it 'returns hash of attributes' do
      is_expected.to eq(attributes)
    end
  end

  describe '#[]' do
    subject { instance[:id] }

    it 'returns called public method' do
      is_expected.to eq(attributes['id'])
    end
  end

  describe '#==' do
    context 'given same object' do
      subject { instance == instance }

      it 'compares attributes and id' do
        is_expected.to be true
      end
    end

    context 'given new object' do
      subject { instance == klass.new }

      it 'compares attributes and id' do
        is_expected.to be false
      end
    end
  end
end
