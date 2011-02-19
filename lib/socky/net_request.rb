# require 'em-http'
#
# module Socky
#   # this class provide unobtrusive http request methods
#   class NetRequest
#     include Socky::Misc
#
#     class << self
#
#       # send unobtrusive http POST request to gived address and return status of request as block response
#       # @param [String] url address to send request in format 'http://address[:port]/[path]'
#       # @param [Hash] params params for request(will be attached in post message)
#       # @yield [Boolean] called after request is finished - if response status is 200 then it's true, else false
#       def post(url, params = {}, &block)
#         http = EventMachine::HttpRequest.new(url).post :body => params, :timeout => options[:timeout] || 3
#         http.errback  { yield false }
#         http.callback { yield http.response_header.status == 200 }
#         true
#       rescue => error
#         error "Bad request", error
#         false
#       end
#
#     end
#
#   end
# end