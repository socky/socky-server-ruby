module Socky
  module Server
    class Channel
      class Public < Base
      
        def subscribe(connection, message)
          self.add_connection(connection)
        end

      end
    end
  end
end
