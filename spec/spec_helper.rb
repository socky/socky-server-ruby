require 'rubygems'
require 'rspec'

require 'socky/server'
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def mock_websocket(application)
  env = {}
  env['PATH_INFO'] = '/websocket/' + application
  connection = Socky::Server::WebSocket.new.call(env)
  send_data_method = connection.method(:send_data)
  connection.stub!(:send_data).and_return do |*args|
    a = send_data_method.call(*args)
  end
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
  }.merge(remains), :allow_changing_rights => true, :secret => 'test_secret')['auth']
end
