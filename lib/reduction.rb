module Reduction
  ROOT = Pathname.new File.expand_path('./..', File.dirname(__FILE__))
end

require 'nokogiri'

require 'core_ext/string'

require 'reduction/strategy'
require 'reduction/strategy/all_recipes'
require 'reduction/version'