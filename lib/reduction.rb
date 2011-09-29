require 'pathname'

module Reduction
  ROOT = Pathname.new File.expand_path('./..', File.dirname(__FILE__))

  class << self

    def strategies
    	Strategy.all
    end

    def supports?(url)
      strategies.any? { |s| s.for_url?(url) }
    end

  end

end

require 'nokogiri'

Dir["#{Reduction::ROOT}/lib/**/*.rb"].each { |f| require f }