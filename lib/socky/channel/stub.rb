module Socky
  class Channel
    class Stub < Base
      
      def subscribe(connection, message)
        self.subscribe_failed(connection)
      end
      
      def unsubscribe(connection, message)
        self.unsubscribe_failed(connection)
      end

    end
  end
end
