require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'distillery'
require 'nokogiri'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'lib/reduction'

def header
  %Q{<!DOCTYPE html>\
  <head>\
    <title>Reduction</title>\
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />\
    <style>img { display: block}</style>\
  </head>\
  <body>}
end

def footer
  %Q{</body>}
end

def form
  %Q{<form method="post"><input type="text" name="url" size="100"  value="#{params['url']}"> \
     </input><input type="submit" value="Submit"></form>}
end

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

def iframe(url)
  "<iframe src=\"#{url}\" width=\"100%\" height=\"500\"></iframe>"
end

def wrapped(*parts)
  base = [Reduction::Strategy.constants.inspect, form] + parts
  header + base.join('<hr>') + footer
end

get '/' do
  wrapped(form)
end

post '/' do
  body = reduce(params['url'])
  body = distill(params['url']) if body.empty?
  wrapped(body, iframe(params['url']))
end