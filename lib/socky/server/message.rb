module Socky
  module Server
    class Message
      include Misc
    
      def initialize(connection, data)
        @connection = connection
        @data = JSON.parse(data) rescue nil
        self.dispath if @data.is_a?(Hash)  
      end
    
      def dispath
        case self.event
          when 'socky:subscribe' then Channel[self.channel].subscribe(@connection, self)
          when 'socky:unsubscribe' then Channel[self.channel].unsubscribe(@connection, self)
        end
      end
    
      # Data from @data part:
    
      def event; @data['event']; end
      def channel; @data['channel'].to_s; end
      def auth; @data['auth']; end
      def read; @data['read']; end
      def write; @data['write']; end
      def hide; @data['hide']; end
    
    end
  end
end
