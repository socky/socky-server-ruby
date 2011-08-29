module Socky
  module Server
    class Channel
      class Base
      
        attr_accessor :application, :name
      
        class << self
          # List of all already registered channels of current type
          # namespaces by application name
          def list
            @list ||= Hash.new{ |hash, key| hash[key] = Hash.new }
          end
        
          # Find channel or create new
          # @param [String] application_name name of application
          # @param [String] channel_name name for channel
          # @return [Base] channel instance
          def find_or_create(application_name, channel_name)
            self.list[application_name][channel_name] ||= self.new(application_name, channel_name)
          end
        end
      
        # Initialize new channel
        # @param [String] application_name name of application
        # @param [String] channel_name name for channel
        def initialize(application_name, channel_name)
          @application = Application.find(application_name)
          @name = channel_name
        end
      
        def subscribers
          @subscribers ||= {}
        end
        
        def send_data(data, except = nil)
          self.subscribers.each do |subscriber_id, subscriber|
            subscriber['connection'].send_data(data) unless subscriber_id == except || !subscriber['read']
          end
        end
        
        def add_subscriber(connection, message, subscriber_data = nil)
          self.subscribers[connection.id] = { 'connection' => connection, 'data' => subscriber_data }.merge( rights(message) )
          connection.channels[self.name] = self
        end
      
        def remove_subscriber(connection)
          self.subscribers.delete(connection.id)
          connection.channels.delete(self.name)
        end
        
        def deliver(connection, message)
          return unless connection.nil? || (subscribers[connection.id] && subscribers[connection.id]['write'])
          send_data(CachedJsonHash['event' => message.event, 'channel' => self.name, 'data' => message.user_data ])
        end
        
        protected
      
        def subscribe_successful(connection, message)
          self.add_subscriber(connection, message)
          connection.send_data('event' => 'socky:subscribe:success', 'channel' => self.name)
        end
      
        def subscribe_failed(connection)
          connection.send_data('event' => 'socky:subscribe:failure', 'channel' => self.name)
        end
      
        def unsubscribe_successful(connection)
          self.remove_subscriber(connection)
          connection.send_data('event' => 'socky:unsubscribe:success', 'channel' => self.name)
        end
      
        def unsubscribe_failed(connection)
          connection.send_data('event' => 'socky:unsubscribe:failure', 'channel' => self.name)
        end

      end
    end
  end
end
