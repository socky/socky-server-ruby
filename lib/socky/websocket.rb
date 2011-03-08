module Socky
  class WebSocket < ::Rack::WebSocket::Application
    include Misc

    DEFAULT_OPTIONS = {
      :debug => false
    }
    
    def initialize(*args)
      super
      
      Logger.enabled = @options[:debug]
    end
    
    # Called when connection is opened
    def on_open
      @connection = Socky::Connection.new(self)
      send_data @connection.initialization_status
    end
    
    # Called when message is received
    def on_message(msg)
      log("message received", msg)
    end
    
    # Called when client closes clonnecton
    def on_close
      @connection.destroy if @connection
    end
    
    # Rack env
    def env
      @env
    end
    
    # Send JSON-encoded data instead of clear text
    def send_data(data)
      jsonified_data = data.to_json
      log('sending', jsonified_data)
      super(jsonified_data)
    end
  end
end