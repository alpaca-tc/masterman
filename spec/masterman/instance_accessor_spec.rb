require 'spec_helper'

RSpec.describe Masterman::InstanceAccessor do
  context 'when initialize model' do
    let(:model) do
      Class.new do
        include Masterman
      end
    end

    def contained_generated_attribute_methods(klass)
      klass.ancestors.any? do |ancestor|
        ancestor.is_a?(Masterman::InstanceAccessor::GeneratedAttributeReaders)
      end
    end

    it 'includes GeneratedAttributeReaders to it' do
      expect(contained_generated_attribute_methods(model)).to be false
      model.new
      expect(contained_generated_attribute_methods(model)).to be true
    end

    context 'with reflections' do
      let(:model) do
        Class.new do
          include Masterman
          attr_reader :user_id

          masterman.belongs_to :user
        end
      end

      before do
        class User
          def self.find(id)
            'hello'
          end
        end
      end

      after do
        Object.send(:remove_const, :User)
      end

      it 'deifnes associations' do
        expect(model.new.user).to eq('hello')
      end
    end
  end

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
