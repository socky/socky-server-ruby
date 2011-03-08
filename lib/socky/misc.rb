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

# module Socky
#   # common methods for all other classes
#   module Misc
#
#     # extend including class by itself
#     def self.included(base)
#       base.extend Socky::Misc
#     end
#
#     # return server-wide options
#     # @see Socky.options
#     def options
#       Socky.options
#     end
#
#     # write server-wide options
#     def options=(ob)
#       Socky.options = ob
#     end
#
#     # return name of current object
#     # @example when included in connection
#     #   @connection.name #=> "Connection(2149785820)"
#     def name
#       "#{self.class.to_s.split("::").last}(#{self.object_id})"
#     end
#
#     # return log path
#     def log_path
#       Socky.log_path
#     end
#
#     # return pid path
#     def pid_path
#       Socky.pid_path
#     end
#
#     # return config path
#     def config_path
#       Socky.config_path
#     end
#
#     # log message at info level
#     # @param [Array] args data for logging
#     def info(args)
#       Socky.logger.info args.join(" ")
#     end
#
#     # log message at debug level
#     # @param [Array] args data for logging
#     def debug(args)
#       Socky.logger.debug args.join(" ")
#     end
#
#     # log message at error level
#     # @param [String] name object name with raised error
#     # @param [Error] error error instance that was raised
#     def error(name, error)
#       debug [name, "raised:", error.class, error.message]
#     end
#
#     # convert keys of hash to symbol
#     # @param [Hash] hash hash to symbolize
#     # @return [Hash] with symbolized keys
#     # @return [Object] if hash isn't instance of Hash
#     def symbolize_keys(hash)
#       return hash unless hash.is_a?(Hash)
#       hash.inject({}) do |options, (key, value)|
#         options[(key.to_sym if key.respond_to?(:to_sym)) || key] = value
#         options
#       end
#     end
#   end
# end