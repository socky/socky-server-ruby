module Socky
  module Server
    class Application
    
      attr_accessor :name, :secret
    
      class << self
        # list of all known applications
        # @return [Hash] list of applications
        def list
          @list ||= {}
        end
      
        # find application from Rack env
        # @param [Hash] env rack env
        # @return [Application] found application or nil
        def find(env)
          name = env['PATH_INFO'].split('/').last
          list[name]
        end
      end
    
      # initialize new application
      # @param [String] name application name
      # @param [String] secret application secret key
      def initialize(name, secret)
        @name = name
        @secret = secret
        self.class.list[name] = self
      end
    
      # list of all connections for this application
      # @return [Hash] hash of all connections
      def connections
        @connections || {}
      end
    
      # add new connection to application
      # @param [Connection] connection connetion to add
      def add_connection(connection)
        self.connections[connection.id] = connection
      end
    
      # remove connection from application
      # @param [Connection] connection connection to remove
      def remove_connection(connection)
        self.connections.delete(connection.id)
      end
    
    end
  end
end
