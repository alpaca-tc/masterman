require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/class/attribute'

require 'masterman/version'
require 'masterman/core'
require 'masterman/association'
require 'masterman/attribute_methods'
require 'masterman/associations'
require 'masterman/reflection'
require 'masterman/loader'
require 'masterman/base'

module Masterman
  class MastermanError < StandardError; end
  class RecordNotFound < MastermanError; end

  extend ActiveSupport::Concern

  included do
    include Core
    include AttributeMethods
  end

  class_methods do
    def masterman
      @masterman ||= Masterman::Base.new
    end

    def configure_masterman(&block)
      masterman.instance_exec(&block)
    end
  end
end
