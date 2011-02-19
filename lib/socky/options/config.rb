# require 'yaml'
# require 'erb'
#
# module Socky
#   class Options
#     # config parser class - used by Socky::Options
#     class Config
#
#       class NoConfigFile < Socky::SockyError; end #:nodoc:
#       class InvalidConfig < Socky::SockyError; end #:nodoc:
#       class AlreadyExists < Socky::SockyError; end #:nodoc:
#       class ConfigUnavailable < Socky::SockyError; end #:nodoc:
#       class SuccessfullyCreated < Socky::SockyError; end #:nodoc:
#
#       class << self
#         # read config file or exits if file don't exists or is invalid
#         # @param [String] path path to valid yaml file
#         # @param [Hash] args args to rescue eventual problems
#         # @option args [Any] kill (nil) if not nil then empty hash will be returned if config file isn't found
#         # @return [Hash] parsed config options
#         # @raise [NoConfigFile] if file doesn't exists
#         # @raise [InvalidConfig] if file isn't valid yaml
#         def read(path, args = {})
#           return {} if path.nil?
#           raise(NoConfigFile, "You must generate a config file (socky -g filename.yml)") unless File.exists?(path)
#           result = YAML::load(ERB.new(IO.read(path)).result)
#           raise(InvalidConfig, "Provided config file is invalid.") unless result.is_a?(Hash)
#           result
#         rescue SockyError => error
#           if args[:kill]
#             return {}
#           else
#             puts error.message
#             exit
#           end
#         end
#
#         # generate default config file
#         # @see DEFAULT_CONFIG_FILE
#         # @param [String] path path to file that will be created
#         # @raise [AlreadyExists] if file exists(you must delete it manually)
#         # @raise [ConfigUnavailable] if file cannot be created(wrong privilages?)
#         # @raise [SuccessfullyCreated] if file is successfully created
#         def generate(path)
#           raise(AlreadyExists, "Config file already exists. You must remove it before generating a new one.") if File.exists?(path)
#           File.open(path, 'w+') do |file|
#             file.write DEFAULT_CONFIG_FILE
#           end rescue raise(ConfigUnavailable, "Config file is unavailable - please choose another.")
#           raise(SuccessfullyCreated, "Config file generated at #{path}")
#         rescue SockyError => error
#           puts error.message
#           exit
#         end
#
#         # default config file content
#         DEFAULT_CONFIG_FILE= <<-EOF
# :port: 8080
# :debug: false
#
# # :subscribe_url: http://localhost:3000/socky/subscribe
# # :unsubscribe_url: http://localhost:3000/socky/unsubscribe
#
# :secret: my_secret_key
#
# :secure: false
#
# # :timeout: 3
#
# # :log_path: /var/log/socky.log
# # :pid_path: /var/run/socky.pid
#
# # :tls_options:
# #   :private_key_file: /private/key
# #   :cert_chain_file: /ssl/certificate
# EOF
#       end
#
#     end
#   end
# end