require 'socky/options/config'
require 'socky/options/parser'

module Socky
  # options parser - reads options from STDIN and config file and set Socky.options
  class Options
    include Socky::Misc

    class << self
      # prepare server-wide options from config and parser
      # @param [Array] argv arguments that will be provided to parser
      # @see default_options default options
      # @see Config.read merged with default options
      # @see Parser.parse merges with default options after config
      def prepare(argv)
        self.options = default_options

        parsed_options = Parser.parse(argv)
        config_options = Config.read(parsed_options[:config_path] || config_path, :kill => parsed_options[:kill])

        self.options.merge!(config_options)
        self.options.merge!(parsed_options)
      end
      
      # default options for server
      def default_options
        {
          :config_path => config_path,
          :port => 8080,
          :debug => false,
          :deep_debug => false,
          :secure => false,
          :log_path => log_path
        }
      end
    end

  end
end