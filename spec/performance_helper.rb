Socky::Server::Channel::Private.class_eval do
  protected

  def check_auth(connection, message)
    true
  end

end


def application_with_listeners count
  @application = Socky::Server::Application.new('test_application', 'test_secret')
  count.times { add_listener }
  add_writer
  @application
end

def add_listener
  websocket = mock_websocket(@application.name)
  env = { 'PATH_INFO' => '/websocket/' + @application.name }
  websocket.on_open(env)
  data = {'event' => 'socky:subscribe', 'channel' => "#{@channel}-channel", 'auth' => 'test_auth'}
  websocket.on_message(env, data)
  websocket
end

def add_writer
  @writer_ws = mock_websocket(@application.name)
  env = { 'PATH_INFO' => '/websocket/' + @application.name }
  @writer_ws.on_open(env)
  data = {'event' => 'socky:subscribe', 'channel' => "#{@channel}-channel", 'write' => 'true', 'auth' => 'test_auth'}
  @writer_ws.on_message(env, data)
  @writer_ws
end

def send_messages count
  env = { 'PATH_INFO' => '/websocket/' + @application.name }
  data = {'event' => 'send', 'channel' => "#{@channel}-channel", 'user_data' => "test_message"}
  count.times { @writer_ws.on_message(env, data) }
end

def clean_application
  @application.connections.values.each {|c| c.destroy}
  Socky::Server::Channel::Private.list['test_application'] = Hash.new
  Socky::Server::Channel::Private.list['test_application'] = Hash.new
  Socky::Server::Application.list.delete('test_application') 
end


def print_result label, results
  avg = results.inject(0.0) { |sum, el| sum + el } / results.size
  puts ["#{label}:".ljust(15), avg].join
end


