module Socky
  module Server
    class Channel
      ROOT = File.expand_path(File.dirname(__FILE__))

      autoload :Base,     "#{ROOT}/channel/base"
      autoload :Presence, "#{ROOT}/channel/presence"
      autoload :Private,  "#{ROOT}/channel/private"
      autoload :Public,   "#{ROOT}/channel/public"
      autoload :Stub,     "#{ROOT}/channel/stub"
    
      # Find or create by application and channel by name
      # @param [String] application_name name of application
      # @param [String] channel_name name of channel
      # @return [Channel::Base] channel instance
      def self.find_or_create(application_name, channel_name)
        return Stub.new(application_name, channel_name) unless (1..30).include?(channel_name.size)
      
        channel_type = case channel_name.match(/\A\w+/).to_s
          when 'private' then Private
          when 'presence' then Presence
          else Public
        end
        
        channel_type.find_or_create(application_name, channel_name)
      end
    
    end
  end
end
