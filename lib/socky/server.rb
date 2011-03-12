require 'rubygems'
require 'rack/websocket'
require 'json'

# Socky is a WebSocket server and client for Ruby
# @author Bernard "Imanel" Potocki
# @see http://github.com/socky/socky-server-ruby main repository
module Socky
  module Server
    VERSION = '0.5.0.pre'
    ROOT = File.expand_path(File.dirname(__FILE__))
  
    autoload :Application, "#{ROOT}/server/application"
    autoload :Channel,     "#{ROOT}/server/channel"
    autoload :Connection,  "#{ROOT}/server/connection"
    autoload :Logger,      "#{ROOT}/server/logger"
    autoload :Message,     "#{ROOT}/server/message"
    autoload :Misc,        "#{ROOT}/server/misc"
    autoload :WebSocket,   "#{ROOT}/server/websocket"
  end
end