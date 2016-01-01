require 'spec_helper'

RSpec.describe Masterman::Collection do
  let(:klass) do
    Class.new do
      include Masterman

      masterman.mount(
        path: File.expand_path('../../fixtures/masterdata.yml', __FILE__),
        loader: :yaml
      )

      masterman.attr_reader :id, :name
    end
  end

  describe '.relation' do
    subject { klass.relation }
    it { is_expected.to be_a(Masterman::Relation) }
  end

  describe 'methods' do
    it 'should not raise error' do
      %i(all first first! last last! exists? any? many? ids).each do |method|
        expect { klass.public_send(method) }.to_not raise_error
      end

      %i(find take take!).each do |method|
        expect { klass.public_send(method, 1) }.to_not raise_error
      end

      %i(pluck).each do |method|
        expect { klass.public_send(method, :id) }.to_not raise_error
      end

      %i(find_by find_by!).each do |method|
        expect { klass.public_send(method, id: 1) }.to_not raise_error
      end
    end
  end
end
