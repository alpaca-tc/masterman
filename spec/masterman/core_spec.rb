require 'spec_helper'

RSpec.describe Masterman::Core do
  context 'when initialize model' do
    let(:model) do
      Class.new do
        include Masterman
      end
    end

    def contained_generated_attribute_methods(klass)
      klass.ancestors.any? do |ancestor|
        ancestor.is_a?(Masterman::Core::GeneratedAttributeMethods)
      end
    end

    it 'includes GeneratedAttributeMethods to it' do
      expect(contained_generated_attribute_methods(model)).to be false
      model.new
      expect(contained_generated_attribute_methods(model)).to be true
    end

    context 'with reflections' do
      let(:model) do
        Class.new do
          include Masterman
          attr_accessor :user_id

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
end
