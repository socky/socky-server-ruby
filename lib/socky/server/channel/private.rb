require File.expand_path(File.dirname(__FILE__)) + '/../../../../../socky-authenticator-ruby/lib/socky/authenticator'

module Socky
  module Server
    class Channel
      class Private < Base
        
        def subscribe(connection, message)
          if check_auth(connection, message)
            self.add_connection(connection)
          else
            self.subscribe_failed(connection)
          end
        end
        
        def unsubscribe(connection, message)
          self.remove_connection(connection)
        end
        
        protected
        
        def check_auth(connection, message)
          return false unless message.auth.is_a?(String) && message.auth.length > 1
          
          hash = self.hash_from_message(connection, message)
          begin
            auth = Socky::Authenticator.new(hash, true, connection.application.secret)
            auth.salt = message.auth.split(':',2)[0]
            auth = auth.result
          rescue ArgumentError => e
            auth = nil
          end
          
          return false unless auth.is_a?(Hash)
          
          auth['auth'] == message.auth
        end
        
        def hash_from_message(connection, message)
          hash = {
            'connection_id' => connection.id,
            'channel' => message.channel
          }
          hash.merge!('read' => message.read) unless message.read.nil?
          hash.merge!('write' => message.write) unless message.write.nil?
          hash
        end

      end
    end
  end
end
