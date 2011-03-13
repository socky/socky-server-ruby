# Start with:
# $ thin -R socky.ru start
require 'lib/socky/server'

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
  run Socky::Server::WebSocket.new :debug => true, :applications => { 'my_app' => 'my_secret' }
end

map '/' do
  run app
end
