require 'rubygems'
require 'rspec'

require 'socky/server'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def mock_connection(application)
  env = {}
  env['PATH_INFO'] = '/websocket/' + application
  connection = Socky::Server::WebSocket.new.call(env)
  connection.stub!(:send_data)
  connection
end