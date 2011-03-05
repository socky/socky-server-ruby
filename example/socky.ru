# Start with:
# $ thin -R socky.ru start
require 'lib/socky'

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

use Rack::CommonLogger

map '/websocket' do
  run Socky::WebSocket.new
end

map '/http' do
  run Socky::HTTP.new
end

map '/' do
  run app
end
