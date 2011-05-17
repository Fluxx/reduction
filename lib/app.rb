require 'rubygems'
require 'sinatra'
require 'open-uri'

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

def reduce(url)
  reduc = reduction(url)
  
  "<table border=1>".tap do |buffer|
    %w[title ingredients steps yields prep_time cook_time].each do |meth|
      buffer << "<tr><td><strong>#{meth}</strong></td><td>"
      result = reduc.send(meth)
      buffer << (result.is_a?(Array) ? '<ol>' + result.map { |e| "<li>#{e}</li>" }.join + '</ol>': result.to_s)
      buffer << "</td></tr>"
    end
    
    buffer << "</table>"
  end
end

def iframe(url)
  "<iframe src=\"#{url}\" width=\"100%\" height=\"500\"></iframe>"
end

get '/' do
  form
end

post '/' do
  [Reduction::Strategy.constants.inspect, form, reduce(params['url']), iframe(params['url'])].join('<hr>')
end