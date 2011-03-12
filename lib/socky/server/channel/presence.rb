module Socky
  module Server
    class Channel
      class Presence < Private
                
        protected
                
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
