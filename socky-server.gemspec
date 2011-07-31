# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "socky/server/version"

Gem::Specification.new do |s|
  s.name        = "socky-server"
  s.version     = Socky::Server::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Bernard Potocki"]
  s.email       = ["bernard.potocki@imanel.org"]
  s.homepage    = "http://socky.org"
  s.summary     = %q{Socky is a WebSocket server and client for Ruby}
  s.description = %q{Socky is a WebSocket server and client for Ruby}
  
  s.add_dependency 'websocket-rack', ">= 0.3.1"
  s.add_dependency 'socky-authenticator', '~> 0.5.0.beta5'
  s.add_dependency 'json'
  s.add_development_dependency 'rspec', '~> 2.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
