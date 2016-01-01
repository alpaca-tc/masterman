require 'active_support/concern'
require 'active_support/inflector'
require 'active_support/core_ext/module/concerning'
require 'active_support/core_ext/module/attribute_accessors'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/array/wrap'

require 'masterman/version'
require 'masterman/core'
require 'masterman/association'
require 'masterman/attribute_methods'
require 'masterman/associations'
require 'masterman/collection'
require 'masterman/reflection'
require 'masterman/relation'
require 'masterman/loader'
require 'masterman/base'

module Masterman
  class MastermanError < StandardError; end
  class RecordNotFound < MastermanError; end

  extend ActiveSupport::Concern

  included do
    include Core
    include AttributeMethods
    extend Collection
  end

  class_methods do
    def masterman(&block)
      @masterman ||= Masterman::Base.new(self)

      if block_given?
        @masterman.instance_exec(&block)
      else
        @masterman
      end
    end
  end
end
