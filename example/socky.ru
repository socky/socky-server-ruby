# Start with:
# $ thin -R socky.ru start
require 'lib/socky/server'

# Cheat a little for now
Socky::Server::Application.new('my_app', 'my_secret')

# Placeholder app
app = proc do |env|
  [
    200,
    {
      'Content-Type' => 'text/html',
      'Content-Length' => '12',
    },
    ['Socky Server']
  ]
end

# use Rack::CommonLogger

map '/websocket' do
  run Socky::Server::WebSocket.new :debug => true
end

map '/' do
  run app
end
