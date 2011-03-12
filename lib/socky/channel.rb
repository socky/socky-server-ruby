module Socky
  class Channel
    ROOT = File.expand_path(File.dirname(__FILE__))

    autoload :Base,     "#{ROOT}/channel/base"
    autoload :Private,  "#{ROOT}/channel/private"
    autoload :Public,   "#{ROOT}/channel/public"
    autoload :Stub,     "#{ROOT}/channel/stub"
    
    # Find or create by channel by name
    # @param [String] name name of channel
    # @return [Channel::Base] channel instance
    def self.find_or_create(channel_name)
      return Stub.new(channel_name) unless (1..30).include?(channel_name.size)
      
      channel_type = case channel_name.match(/\A\w+/).to_s
        when 'private' then Private
        else Public
      end
      
      channel_type.find_or_create(channel_name)
    end

    # Alias for self.find_or_create
    def self.[](channel_name)
      self.find_or_create(channel_name)
    end
    
  end
end
