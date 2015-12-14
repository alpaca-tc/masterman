require 'masterman_spec'

RSpec.describe Masterman::Mountable do
  def mount_class(&block)
    Class.new do
      include ActiveModel::Model
      include Masterman::Mountable
      mount_data from: File.expand_path('../../fixtures/masterdata.yml', __FILE__), loader: :yaml
      attribute_accessor :id, :name
      self.class_eval(&block) if block_given?
    end
  end

  describe 'ClassMethods' do
    describe '.primary_id=' do
      let(:mounted) do
        mount_class do
          self.primary_key = :custom_id
        end
      end

      it 'set primary_id' do
        expect(mounted.primary_key).to eq(:custom_id)
      end
    end

    describe '.attribute_accessor' do
      let(:mounted) do
        mount_class do
          attribute_accessor :name
        end
      end

      it 'defines accessor' do
        expect(mounted.first.name).to be_a(String)
      end
    end

    describe '.find' do
      subject { mount_class.find(id) }

      context 'if record is exist' do
        let(:id) { 1 }

        it 'finds by id' do
          is_expected.to be_a(described_class)
        end
      end

      context 'if record is not exist' do
        let(:id) { 10 }

        it 'raise not found error' do
          expect { subject }.to raise_error(described_class::RecordNotFound)
        end
      end
    end
  end

  describe 'InstanceMethods' do
  end
end
