module Socky
  module Server
    class HTTP
      include Misc
      
      class ConnectionError < RuntimeError; attr_accessor :status; end
      
      DEFAULT_OPTIONS = {
        :debug => false,
        :timestamp_deviation => 10
      }
      
      def initialize(options = {})
        @options = DEFAULT_OPTIONS.merge(options)
        Config.new(@options)
      end
      
      def call(env)
        request = Rack::Request.new(env.merge('CONTENT_TYPE' => nil))
        @params = request.params
        log("received", @params)
        
        @app_name = request.path.split('/').last
        
        check_app
        check_channel
        
        check_timestamp
        check_auth
        
        channel = Channel.find_or_create(@app_name, @params['channel'])
        channel.deliver(nil, Message.new(nil, @params))
        
        [202, {}, ['Event sent']]
      rescue ConnectionError => e
        [ e.status, {}, [e.message] ]
      rescue
        [ 500, {}, ['Unknown error'] ]
      end
      
      private
      
      def app
        @app ||= Application.find(@app_name)
      end
      
      def check_app
        error = ConnectionError.new 'Application not found'
        error.status = 404
        
        raise error if app.nil?
      end
      
      def check_channel
        error = ConnectionError.new 'No channel provided'
        error.status = 400
        
        raise error unless @params['channel']
      end
      
      def check_timestamp
        error = ConnectionError.new 'Invalid timestamp'
        error.status = 401
        
        timestamp = @params['timestamp'].to_i
        current_time = Time.now.to_i
        min_time = current_time - (@options[:timestamp_deviation] * 60)
        max_time = current_time + (@options[:timestamp_deviation] * 60)
        
        raise error unless timestamp > min_time && timestamp < max_time
      end
      
      def check_auth
        error = ConnectionError.new 'Invalid auth token'
        error.status = 401
        
        auth = @params['auth']
        authenticator = Authenticator.new({
          :connection_id => @params['timestamp'],
          :channel => @params['channel'],
          :event => @params['event'],
          :data => @params['data']
        }, {
          :secret => app.secret,
          :method => :http
        })
        authenticator.salt = @params['auth'].split(':',2)[0]
        result = authenticator.result
        
        raise error unless result.is_a?(Hash) && result['auth'] == auth
      end
      
    end
  end
end
