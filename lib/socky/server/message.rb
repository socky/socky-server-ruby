module Socky
  module Server
    class Message
      include Misc
    
      def initialize(connection, data)
        @connection = connection
        @data = data.is_a?(Hash) ? data : JSON.parse(data) rescue nil
        @data ||= {}
      end
    
      def dispath
        case self.event
          when 'socky:subscribe' then Channel.find_or_create(@connection.application.name, self.channel).subscribe(@connection, self)
          when 'socky:unsubscribe' then Channel.find_or_create(@connection.application.name, self.channel).unsubscribe(@connection, self)
        else
          unless self.event.match(/\Asocky:/)
            Channel.find_or_create(@connection.application.name, self.channel).deliver(@connection, self)
          end
        end
      end
    
      # Data from @data part:
    
      def event; @data['event'].to_s; end
      def channel; @data['channel'].to_s; end
      def user_data; @data['data']; end
      def auth; @data['auth']; end
      def read; @data['read']; end
      def write; @data['write']; end
      def hide; @data['hide']; end
    
    end
  end
end
