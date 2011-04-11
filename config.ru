# Start with:
# $ thin -R socky.ru start
current_dir = File.expand_path(File.dirname(__FILE__))
require current_dir + '/lib/socky/server'

# use Rack::CommonLogger

map '/websocket' do
  run Socky::Server::WebSocket.new :config_file => current_dir + '/example/config.yml', :debug => true
end
