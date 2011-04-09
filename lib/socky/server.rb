require 'rubygems'
require 'json'
require 'rack/websocket'
require 'socky/authenticator'

# Socky is a WebSocket server and client for Ruby
# @author Bernard "Imanel" Potocki
# @see http://github.com/socky/socky-server-ruby main repository
module Socky
  module Server
    ROOT = File.expand_path(File.dirname(__FILE__))
  
    autoload :Application, "#{ROOT}/server/application"
    autoload :Channel,     "#{ROOT}/server/channel"
    autoload :Config,      "#{ROOT}/server/config"
    autoload :Connection,  "#{ROOT}/server/connection"
    autoload :Logger,      "#{ROOT}/server/logger"
    autoload :Message,     "#{ROOT}/server/message"
    autoload :Misc,        "#{ROOT}/server/misc"
    autoload :WebSocket,   "#{ROOT}/server/websocket"
  end
end