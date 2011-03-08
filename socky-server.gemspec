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
  
  s.add_dependency 'websocket-rack'
  s.add_dependency 'json'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
