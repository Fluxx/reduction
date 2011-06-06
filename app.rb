require 'rubygems'
require 'sinatra'
require 'open-uri'
require 'distillery'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require 'reduction'

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
  return "" if reduc.empty?
  
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
  doc = Distillery.distill(open(url).read)
  "<pre style='width: 1000px; white-space: pre-line;'>#{Nokogiri::HTML(doc).text}</pre>"
end

def iframe(url)
  "<iframe src=\"#{url}\" width=\"100%\" height=\"500\"></iframe>"
end

get '/' do
  form
end

post '/' do
  body = reduce(params['url'])
  body = distill(params['url']) if body.empty?
  [Reduction::Strategy.constants.inspect, form, body, iframe(params['url'])].join('<hr>')
end