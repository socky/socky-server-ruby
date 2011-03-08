module Socky
  module Misc
    
    # extend including class by itself
    def self.included(base)
      base.extend Socky::Misc
    end
    
    # log message
    # @param [Array] args data for logging
    def log(*args)
      Logger.log *args
    end
    
  end
end
