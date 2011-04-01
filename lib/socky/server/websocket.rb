module Socky
  module Server
    class WebSocket < ::Rack::WebSocket::Application
      include Misc

      DEFAULT_OPTIONS = {
        :debug => false
      }
      
      attr_reader :connection
    
      def initialize(*args)
        super
        
        Config.new(@options)
      end
    
      # Called when connection is opened
      def on_open(env)
        app_name = env['PATH_INFO'].split('/').last
        @connection = Connection.new(self, app_name)
      end
    
      # Called when message is received
      def on_message(env, msg)
        log("received", msg)
        Message.new(@connection, msg)
      end
    
      # Called when client closes clonnecton
      def on_close(env)
        @connection.destroy if @connection
      end
    
      # Send JSON-encoded data instead of clear text
      def send_data(data)
        jsonified_data = data.to_json
        log('sending', jsonified_data)
        super(jsonified_data)
      end
    end
  end
end
