require 'spec_helper'

RSpec.describe Masterman::Reflection do
  let(:included) do
    Class.new do
      include Masterman::Reflection
    end
  end

  let(:instance) { included.new }

  describe 'InstanceMethods' do
    describe '#reflections' do
      it 'defines blank reflections' do
        expect(instance.reflections).to eq({})
      end
    end
  end

  describe 'ClassMethods' do
    describe '.build' do
      let(:model_class) { Class.new }
      let(:scope) { nil }
      let(:options) do
        {}
      end

      subject do
        described_class.build(macro, name, scope, options, model_class)
      end

      shared_examples_for 'with :through option' do
        let(:options) do
          { through: :item }
        end

        it 'returns ThroughReflection' do
          is_expected.to be_a(described_class::ThroughReflection)
        end
      end

      context 'given belong_to as macro' do
        let(:macro) { :belongs_to }
        let(:name) { :user }

        it 'returns BelongsToReflection' do
          is_expected.to be_a(described_class::BelongsToReflection)
        end
      end

      context 'given has_one as macro' do
        let(:macro) { :has_one }
        let(:name) { :user }

        it 'returns HasOneReflection' do
          is_expected.to be_a(described_class::HasOneReflection)
        end

        it_behaves_like 'with :through option'
      end

      context 'given has_many as macro' do
        let(:macro) { :has_many }
        let(:name) { :users }

        it 'returns HasManyReflection' do
          is_expected.to be_a(described_class::HasManyReflection)
        end

        it_behaves_like 'with :through option'
      end
    end

    describe '.add_reflection' do
      subject { described_class.add_reflection(instance, 'user', reflection) }

      let(:reflection) do
        described_class::BelongsToReflection.new('user', nil, {}, Class.new)
      end

      it 'adds reflection' do
        expect(instance.reflections).to eq({})
        subject
        expect(instance.reflections).to eq({ 'user' => reflection })
      end
    end
  end
end
