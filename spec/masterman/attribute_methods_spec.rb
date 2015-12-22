require 'spec_helper'

RSpec.describe Masterman::AttributeMethods do
  let(:klass) do
    Class.new do
      include Masterman
      masterman.attribute_accessor :id
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
end
