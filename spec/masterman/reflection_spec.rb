require 'spec_helper'

RSpec.describe Masterman::Reflection do
  let(:included) do
    Class.new do
      include Masterman::Reflection
    end
  end

  let(:instance) { included.new }

  describe 'InstanceMethods' do
    describe '#_reflections' do
      it 'defines blank reflections' do
        expect(instance._reflections).to eq({})
      end
    end
  end

  describe 'ClassMethods' do
    describe '.add_reflection' do
      subject { described_class.add_reflection(instance, 'user', reflection) }

      let(:reflection) do
        described_class::BelongsToReflection.new('user', nil, {}, Class.new)
      end

      it 'adds reflection' do
        expect(instance._reflections).to eq({})
        subject
        expect(instance._reflections).to eq({ 'user' => reflection })
      end
    end
  end
end
