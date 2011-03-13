# Start with:
# $ thin -R socky.ru start
require 'lib/socky/server'

# use Rack::CommonLogger

map '/websocket' do
  run Socky::Server::WebSocket.new :debug => true, :applications => { 'my_app' => 'my_secret' }
end
