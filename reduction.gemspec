# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "reduction/version"

Gem::Specification.new do |s|
  s.name        = "reduction"
  s.version     = Reduction::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Pollard"]
  s.email       = ["jeff.pollard@gmail.com"]
  s.homepage    = "https://github.com/Fluxx/reduction"
  s.summary     = %q{Extract just the recipe from common recipe websites.}
  s.description = %q{Extract just the recipe from common recipe websites.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('nokogiri', '> 1.0')
  s.add_dependency('sinatra')
  
  s.add_development_dependency('rspec', '> 2.0')
  s.add_development_dependency('guard')
  s.add_development_dependency('guard-rspec')
  s.add_development_dependency('ruby-debug19')
  s.add_development_dependency('rb-fsevent')
  s.add_development_dependency('growl')
  s.add_development_dependency('vcr')
  s.add_development_dependency('fakeweb')
end
