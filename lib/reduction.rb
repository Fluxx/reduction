require 'pathname'
require 'reduction/strategy'

module Reduction
  ROOT = Pathname.new(File.expand_path(File.dirname(__FILE__)))

  class << self

    def strategies
    	Strategy.all
    end

    def supports?(url)
      strategies.any? { |s| s.for_url?(url) }
    end

  end

end

Reduction::ROOT.join('reduction/strategy').each_child { |s| require s.to_s }