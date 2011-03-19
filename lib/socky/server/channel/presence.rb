module Socky
  module Server
    class Channel
      class Presence < Private
        
        def add_subscriber(connection, subscriber_data = nil)
          self.send_data({ 'event' => 'socky_internal:member:added', 'connection_id' => connection.id, 'channel' => self.name, 'data' => subscriber_data }, connection.id)
          super
        end
      
        def remove_subscriber(connection)
          self.send_data({ 'event' => 'socky_internal:member:removed', 'connection_id' => connection.id, 'channel' => self.name }, connection.id)
          super
        end
                
        protected
        
        def subscribe_successful(connection, message)
          user_data = JSON.parse(message.user_data) rescue nil
          user_data = {} unless user_data.is_a?(Hash)
          
          self.add_subscriber(connection, user_data)
          connection.send_data('event' => 'socky_internal:subscribe:success', 'channel' => self.name, 'members' => member_list(connection))
        end
        
        def member_list(connection)
          list = []
          self.subscribers.each do |connection_id, member|
            list << { 'connection_id' => connection_id, 'data' => member['data'] } unless connection_id == connection.id
          end
          list
        end
                
        def hash_from_message(connection, message)
          hash = super
          hash.merge!('data' => message.user_data)
          hash.merge!('hide' => message.hide) unless message.hide.nil?
          hash
        end

      end
    end
  end
end
