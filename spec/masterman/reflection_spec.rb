require 'spec_helper'

RSpec.describe Masterman::Reflection do
  let(:included) do
    Class.new do
      include Masterman::Reflection
    end
  end

  describe 'initial state' do
    it 'defines blank reflections' do
      expect(included._reflections).to eq({})
    end
  end

  describe Masterman::Reflection::Macro do
    let(:macro) do
      scope = -> (r) { r.id == 1 }
      described_class.new(name, scope, { foreign_key: foreign_key }, klass)
    end

    let(:name) { :user }

    let(:klass) do
      Class.new
    end

    let(:foreign_key) { nil }

    describe '#foreign_key' do
      subject { macro.foreign_key }

      fcontext 'with foreign_key' do
        let(:foreign_key) { :new_user_id }

        it 'returns foregin_key' do
          is_expected.to eq('new_user_id')
        end
      end

      context 'without foregin_key' do
        it 'returns foregin_key' do
          is_expected.to eq('user_id')
        end
      end
    end

    describe '#klass' do
      subject { macro.klass }

      before do
        class User; end
        allow(macro).to receive(:collection?).and_return(collection?)
      end

      after do
        Object.send(:remove_const, :User)
      end

      context 'when reflection is collection' do
        let(:name) { :users }
        let(:collection?) { true }

        it 'returns klass name' do
          is_expected.to eq(User)
        end
      end

      context 'when reflection is singular' do
        let(:collection?) { false }

        it 'returns klass name' do
          is_expected.to eq(User)
        end
      end
    end
  end
end
