require 'rubygems'
require 'rack/websocket'
require 'json'

# Socky is a WebSocket server and client for Ruby
# @author Bernard "Imanel" Potocki
# @see http://github.com/socky/socky-server-ruby main repository
module Socky
  VERSION = '0.5.0.pre'
  ROOT = File.expand_path(File.dirname(__FILE__))
  
  autoload :Application, "#{ROOT}/socky/application"
  autoload :Channel,     "#{ROOT}/socky/channel"
  autoload :Connection,  "#{ROOT}/socky/connection"
  autoload :Logger,      "#{ROOT}/socky/logger"
  autoload :Misc,        "#{ROOT}/socky/misc"
  autoload :WebSocket,   "#{ROOT}/socky/websocket"
end
