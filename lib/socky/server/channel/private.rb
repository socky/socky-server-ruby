module Socky
  module Server
    class Channel
      class Private < Public
                
        protected
        
        def check_auth(connection, message)
          return false unless message.auth.is_a?(String) && message.auth.length > 1
          
          hash = self.hash_from_message(connection, message)
          begin
            auth = Socky::Authenticator.new(hash, :allow_changing_rights => true, :secret => self.application.secret)
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
          hash.merge!( rights(message) )
          hash
        end
        
        def rights(message)
          r = super
          r.merge!( 'read' => !!message.read ) unless message.read.nil?
          r.merge!( 'write' => !!message.write ) unless message.write.nil?
          r
        end

      end
    end
  end
end
