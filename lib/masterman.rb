require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/core_ext/module/attribute_accessors'
require 'masterman/version'
require 'masterman/core'
require 'masterman/association'
require 'masterman/associations'
require 'masterman/reflection'
require 'masterman/loader'
require 'masterman/base'

module Masterman
  class MastermanError < StandardError; end
  class RecordNotFound < MastermanError; end

  extend ActiveSupport::Concern

  included do
    cattr_accessor :masterman
    self.masterman = Masterman::Base.new(self)
  end

  class_methods do
    def configure_masterman(&block)
      block.call(self.masterman)
    end
  end
end
