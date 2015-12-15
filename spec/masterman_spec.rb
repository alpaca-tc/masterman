require 'spec_helper'

RSpec.describe Masterman do
  it 'has a version number' do
    expect(Masterman::VERSION).not_to be nil
  end

  describe 'include Masterman' do
    let(:included) do
      Class.new do
        include Masterman
      end
    end

    it 'defines .masterman' do
      expect(included.masterman).to be_a(Masterman::Base)
    end

    it 'defines .configure_masterman' do
      masterman = included.configure_masterman { |masterman| masterman }
      expect(masterman).to be_a(Masterman::Base)
    end
  end
end
