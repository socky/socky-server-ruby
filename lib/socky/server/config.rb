module Socky
  module Server
    class Config
      
      # Each config key calls corresponding method with value as param
      def initialize(config = {})
        return unless config.is_a?(Hash)
        config.each { |key, value| self.send(key, value) if self.respond_to?(key) }
      end
      
      # Enable or disable debug
      def debug(arg)
        Logger.enabled = !!arg
      end
      
      # List of applications if Hash form where key is app name
      # and value is app secret.
      # @example valid hash
      #   { 'my_app_name' => 'my_secret' }
      def applications(arg)
        raise ArgumentError, 'expected Hash' unless arg.is_a?(Hash)
        
        arg.each do |app_name, app_secret|
          Socky::Server::Application.new(app_name.to_s, app_secret.to_s)
        end
      end
      
    end
  end
end
