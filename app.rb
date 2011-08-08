require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'distillery'
require 'nokogiri'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'lib/reduction'

def reduction(url)
  Reduction::Strategy.constants.each do |klass|
    strategy = Reduction::Strategy.const_get(klass)
    if strategy.for_url?(url)
      return strategy.new(open(url).read)
    end
  end
  
  ''
end

def convert_result(result)
  result.is_a?(Array) ? '<ol>' + result.map { |e| "<li>#{convert_result(e)}</li>" }.join + '</ol>': result.to_s
end

def reduce(url)
  reduc = reduction(url)
  return "" if reduc.is_a?(String) && reduc.empty?
  
  "<table border=1>".tap do |buffer|
    %w[title ingredients steps yields prep_time cook_time].each do |meth|
      buffer << "<tr><td><strong>#{meth}</strong></td><td>"
      result = reduc.send(meth)
      buffer << convert_result(result)
      buffer << "</td></tr>"
    end
    
    buffer << "</table>"
  end
end

def distill(url)
  doc = Distillery.distill(open(url).read, :images => true)
  Nokogiri::HTML(doc).to_s
end

get '/' do
  erb :new
end

post '/' do
  @url = params['url']
  @result = reduce(params['url'])
  @result = distill(params['url']) if body.empty?
  erb :show
end