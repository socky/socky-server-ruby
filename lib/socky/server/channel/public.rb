module Socky
  module Server
    class Channel
      class Public < Base
      
        def subscribe(connection, message)
          self.add_connection(connection)
        end
        
        def unsubscribe(connection, message)
          self.remove_connection(connection)
        end

      end
    end
  end
end
