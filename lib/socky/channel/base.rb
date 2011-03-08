module Socky
  class Channel
    class Base
      
      attr_accessor :name
      
      class << self
        # List of all already registered channels of current type
        def list
          @list ||= {}
        end
        
        # Find channel or create new
        # @param [String] name name for channel
        # @return [Base] channel instance
        def find_or_create(name)
          list[name] ||= self.new(name)
        end
      end
      
      # Initialize new channel
      # @param [String] name name for channel
      def initialize(name)
        @name = name
      end

    end
  end
end
