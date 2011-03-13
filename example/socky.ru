# Start with:
# $ thin -R socky.ru start
require File.expand_path(File.dirname(__FILE__)) + '/../lib/socky/server'

# use Rack::CommonLogger

map '/websocket' do
  run Socky::Server::WebSocket.new :config_file => 'config.yml', :debug => true
end
