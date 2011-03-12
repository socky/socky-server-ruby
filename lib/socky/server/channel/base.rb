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
      
        def subscribers
          @subscribers ||= {}
        end
        
        def send_data(data)
          self.subscribers.each { |subscriber_id, subscriber| subscriber['connection'].send_data(data) }
        end
        
        def add_subscriber(connection, subscriber_data = nil)
          self.subscribers[connection.id] = { 'connection' => connection, 'data' => subscriber_data }
          connection.channels[self.name] = self
        end
      
        def remove_subscriber(connection)
          self.subscribers.delete(connection.id)
          connection.channels.delete(self.name)
        end
        
        protected
      
        def subscribe_successful(connection, message)
          self.add_subscriber(connection)
          connection.send_data('event' => 'socky_internal:subscribe:success', 'channel' => self.name)
        end
      
        def subscribe_failed(connection)
          connection.send_data('event' => 'socky_internal:subscribe:failure', 'channel' => self.name)
        end
      
        def unsubscribe_successful(connection)
          self.remove_subscriber(connection)
          connection.send_data('event' => 'socky_internal:unsubscribe:success', 'channel' => self.name)
        end
      
        def unsubscribe_failed(connection)
          connection.send_data('event' => 'socky_internal:unsubscribe:failure', 'channel' => self.name)
        end

      end
    end
  end
end
