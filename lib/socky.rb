require 'rubygems'
require 'rack/websocket'

module Socky
  VERSION = '0.5.0.pre'
  ROOT = File.expand_path(File.dirname(__FILE__))
  
  autoload :HTTP,      "#{ROOT}/socky/http"
  autoload :WebSocket, "#{ROOT}/socky/websocket"
end


# require 'rubygems'
# require 'logger'
# require 'fileutils'
# require 'em-websocket'
# $:.unshift(File.dirname(__FILE__))
# require 'em-websocket_hacks'
#
# # Socky is a WebSocket server and client for Ruby on Rails
# # @author Bernard "Imanel" Potocki
# # @see http://github.com/imanel/socky_gem main repository
# module Socky
#
#   class SockyError < StandardError; end #:nodoc:
#
#   # server version
#   VERSION = File.read(File.dirname(__FILE__) + '/../VERSION').strip
#
#   class << self
#     # read server-wide options
#     def options
#       @options ||= {}
#     end
#
#     # write server-wide options
#     def options=(val)
#       @options = val
#     end
#
#     # access or initialize logger
#     # default logger writes to STDOUT
#     def logger
#       return @logger if defined?(@logger) && !@logger.nil?
#       path = log_path
#       FileUtils.mkdir_p(File.dirname(path))
#       prepare_logger(path)
#     rescue
#       prepare_logger(STDOUT)
#     end
#
#     # overwrite default logger
#     def logger=(logger)
#       @logger = logger
#     end
#
#     # default log path
#     def log_path
#       options[:log_path] || nil
#     end
#
#     # default pid path
#     def pid_path
#       options[:pid_path] || File.join(%w( / var run socky.pid ))
#     end
#
#     # default config path
#     def config_path
#       options[:config_path] || nil
#     end
#
#     private
#
#     def prepare_logger(output)
#       @logger = Logger.new(output)
#       @logger.level = Logger::INFO unless options[:debug]
#       @logger
#     end
#   end
# end
#
# require 'socky/misc'
# require 'socky/options'
# require 'socky/runner'
# require 'socky/connection'
# require 'socky/net_request'
# require 'socky/message'