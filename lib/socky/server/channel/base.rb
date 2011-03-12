module Socky
  module Server
    class Channel
      class Base
      
        attr_accessor :name
      
        class << self
          # List of all already registered channels of current type
          def list
            @list ||= {}
          end
        
          # Find channel or create new
          # @param [String] name name for channel
          # @return [Base] channel instance
          def find_or_create(name)
            self.list[name] ||= self.new(name)
          end
        end
      
        # Initialize new channel
        # @param [String] name name for channel
        def initialize(name)
          @name = name
        end
      
        def connections
          @connections ||= {}
        end
        
        protected
      
        def subscribe_successful(connection)
          self.add_connection(connection)
          connection.send_data('event' => 'socky_internal:subscribe:success', 'channel' => self.name)
        end
      
        def subscribe_failed(connection)
          connection.send_data('event' => 'socky_internal:subscribe:failure', 'channel' => self.name)
        end
      
        def unsubscribe_successful(connection)
          self.remove_connection(connection)
          connection.send_data('event' => 'socky_internal:unsubscribe:success', 'channel' => self.name)
        end
      
        def unsubscribe_failed(connection)
          connection.send_data('event' => 'socky_internal:unsubscribe:failure', 'channel' => self.name)
        end
        
        def add_connection(connection)
          self.connections[connection.id] = connection
          connection.channels[self.name] = self
        end
      
        def remove_connection(connection)
          self.connections.delete(connection.id)
          connection.channels.delete(self.name)
        end

      end
    end
  end
end
