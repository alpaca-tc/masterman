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

    describe '#class_mount' do
      describe 'with :path options' do
        let(:mounted) do
          Class.new do
            include Masterman

            masterman.class_mount(
              path: File.expand_path('../../fixtures/class_masterdata.yml', __FILE__),
              loader: :yaml
            )

            masterman.cattr_reader :name, :url

            masterman.mount_class_attributes!
          end
        end

        it 'mount data from path' do
          expect(mounted.masterman.class_loader.all).to_not be_empty
        end
      end
    end

    describe '#mount' do
      describe 'with :direct options' do
        let(:mounted) do
          _records = records

          Class.new do
            include Masterman

            masterman.mount(direct: _records)
            masterman.attr_reader :id
          end
        end

        let(:records) { [{ id: 1 }] }

        it 'mount data directly' do
          expect(mounted.masterman.loader.all).to_not be_empty
        end
      end

      describe 'with :path options' do
        let(:mounted) do
          Class.new do
            include Masterman

            masterman.mount(
              path: File.expand_path('../../fixtures/masterdata.yml', __FILE__),
              loader: :yaml
            )

            masterman.attr_reader :id, :name
          end
        end

        it 'mount data from path' do
          expect(mounted.masterman.loader.all).to_not be_empty
        end
      end
    end
  end
end
