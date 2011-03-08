module Socky
  class Channel
    ROOT = File.expand_path(File.dirname(__FILE__))

    autoload :Base,     "#{ROOT}/channel/base"
    autoload :Private,  "#{ROOT}/channel/private"
    autoload :Public,   "#{ROOT}/channel/public"
    
    # Find or create by channel by name
    # @param [String] name name of channel
    # @return [Channel::Base] channel instance
    def self.find_or_create(name)
      channel_type = case name.match(/\A\w+/).to_s
        when 'private' then Private
        else Public
      end
      
      channel_type.find_or_create(name)
    end
  end
end
