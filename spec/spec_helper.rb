require 'rubygems'
require 'rspec'

require 'socky/server'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def mock_websocket(application)
  env = {}
  env['PATH_INFO'] = '/websocket/' + application
  connection = Socky::Server::WebSocket.new.call(env)
  connection.stub!(:send_data)
  connection
end

def mock_connection(application)
  websocket = mock_websocket(application)
  
  env = { 'PATH_INFO' => '/websocket/' + application }
  websocket.on_open(env)
end
