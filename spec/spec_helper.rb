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

def auth_token(socket, channel_name, remains = {})
  Socky::Authenticator.authenticate({
    'connection_id' => socket.connection.id,
    'channel' => channel_name
  }.merge(remains), true, 'test_secret')['auth']
end