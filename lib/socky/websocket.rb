module Socky
  class WebSocket < ::Rack::WebSocket::Application

    DEFAULT_OPTIONS = {
      :debug => false
    }

    def on_open
      puts "client connected"
    end

    def on_message(msg)
      puts "message received: " + msg
    end

    def on_close
      puts "client disconnected"
    end
  end
end