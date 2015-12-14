require 'active_support/concern'
require 'active_support/core_ext/module/attribute_accessors'
require 'masterman/version'
require 'masterman/core'
require 'masterman/loader'

module Masterman
  class MastermanError < StandardError; end
  class RecordNotFound < MastermanError; end
end
