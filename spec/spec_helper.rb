require 'rubygems'
require 'spec'
require "spec/autorun"

require 'socky'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}