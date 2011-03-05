# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "socky"

Gem::Specification.new do |s|
  s.name        = "socky"
  s.version     = Socky::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bernard Potocki"]
  s.email       = ["bernard.potocki@imanel.org"]
  s.homepage    = "http://imanel.org/projects/socky"
  s.summary     = %q{Socky is a WebSocket server and client for Ruby}
  s.description = %q{Socky is a WebSocket server and client for Ruby}
  
  s.add_dependency 'em-websocket', '>= 0.1.4'
  s.add_dependency 'em-http-request'
  s.add_dependency 'json'
  s.add_development_dependency 'rspec', '~> 2.0'
  s.add_development_dependency 'rack'
  s.add_development_dependency 'mongrel'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
