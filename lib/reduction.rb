module Reduction
  ROOT = Pathname.new File.expand_path('./..', File.dirname(__FILE__))
end

require 'nokogiri'

Dir["#{Reduction::ROOT}/lib/**/*.rb"].each { |f| require f }