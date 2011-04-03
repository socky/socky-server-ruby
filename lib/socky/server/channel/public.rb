module Socky
  module Server
    class Channel
      class Public < Base
      
        def subscribe(connection, message)
          if self.check_auth(connection, message)
            self.subscribe_successful(connection, message)
          else
            self.subscribe_failed(connection)
          end
        end
        
        def unsubscribe(connection, message)
          if self.connected?(connection)
            unsubscribe_successful(connection)
          else
            unsubscribe_failed(connection)
          end
        end
        
        protected
        
        def connected?(connection)
          !!self.subscribers[connection.id]
        end
        
        def check_auth(connection, message)
          true
        end
        
        def rights(message)
          {
            'read' =>  true,
            'write' => false,
            'hide' =>  false
          }
        end

      end
    end
  end
end
