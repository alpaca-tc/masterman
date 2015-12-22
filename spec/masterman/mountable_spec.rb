require 'spec_helper'

RSpec.describe Masterman::Mountable do
  describe 'ClassMethods' do
    describe '#primary_id=' do
      let(:mounted) do
        Class.new do
          include Masterman
          masterman.primary_key = :custom_id
        end
      end

      it 'set primary_id' do
        expect(mounted.masterman.primary_key).to eq(:custom_id)
      end
    end

    describe '#mount_options' do
      describe 'with :direct options' do
        let(:mounted) do
          _records = records

          Class.new do
            include Masterman

            masterman.mount_options = { direct: _records }
            masterman.attribute_accessor :id
          end
        end

        let(:records) { [{ id: 1 }] }

        it 'mount data directly' do
          expect(mounted.masterman.all).to be_present
        end
      end

      describe 'with :file options' do
        let(:mounted) do
          Class.new do
            include Masterman

            masterman.mount_options = {
              file: File.expand_path('../../fixtures/masterdata.yml', __FILE__),
              loader: :yaml
            }

            masterman.attribute_accessor :id, :name
          end
        end

        it 'mount data from file' do
          expect(mounted.masterman.all).to be_present
        end
      end
    end
  end
end
