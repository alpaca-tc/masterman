require 'spec_helper'

RSpec.describe Masterman::Reflection::Macro do
  let(:macro) do
    described_class.new(name, scope, options, klass)
  end

  let(:name) { :user }
  let(:scope) { nil }
  let(:options) do
    { foreign_key: foreign_key }
  end
  let(:foreign_key) { nil }
  let(:klass) { Class.new }

  describe '#foreign_key' do
    subject { macro.foreign_key }

    context 'with foreign_key' do
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
