# require 'optparse'
#
# module Socky
#   class Options
#     # STDIN options parser - used by Socky::Options
#     class Parser
#
#       class << self
#         # parse options(usually from STDIN)
#         # see source code for available options
#         # @param [Array] argv options for parser
#         # @return [Hash] parsed options from array
#         def parse(argv)
#           result = {}
#           opts = OptionParser.new do |opts|
#             opts.summary_width = 25
#             opts.banner = "Usage: socky [options]\n"
#
#             opts.separator ""
#             opts.separator "Configuration:"
#
#             opts.on("-g", "--generate FILE", String, "Generate config file") do |path|
#               result[:config_path] = File.expand_path(path) if path
#               Config.generate(result[:config_path])
#             end
#
#             opts.on("-c", "--config FILE", String, "Path to configuration file.") do |path|
#               result[:config_path] = File.expand_path(path)
#             end
#
#             opts.separator ""; opts.separator "Network:"
#
#             opts.on("-p", "--port PORT", Integer, "Specify port", "(default: 8080)") do |port|
#               result[:port] = port
#             end
#
#             opts.on("-s", "--secure", "Run in wss/ssl mode") do
#               result[:secure] = true
#             end
#
#             opts.separator ""; opts.separator "Daemonization:"
#
#             opts.on("-d", "--daemon", "Daemonize mode") do
#               result[:daemonize] = true
#             end
#
#             opts.on("-P", "--pid FILE", String, "Path to PID file when using -d option") do |path|
#               result[:pid_path] = File.expand_path(path)
#             end
#
#             opts.on("-k", "--kill", "Kill daemon from specified pid file path") do
#               result[:kill] = true
#             end
#
#             opts.separator ""; opts.separator "Logging:"
#
#             opts.on("-l", "--log FILE", String, "Path to print debugging information.", "(Print to STDOUT if empty)") do |path|
#               result[:log_path] = File.expand_path(path)
#             end
#
#             opts.on("--debug", "Run in debug mode") do
#               result[:debug] = true
#             end
#
#             opts.on("--deep-debug", "Run in debug mode that is even more verbose") do
#               result[:debug] = true
#               result[:deep_debug] = true
#             end
#
#             opts.separator ""; opts.separator "Miscellaneous:"
#
#             opts.on_tail("-?", "--help", "Display this usage information.") do
#               puts "#{opts}\n"
#               exit
#             end
#
#             opts.on_tail("-v", "--version", "Display version") do
#               puts "Socky #{VERSION}"
#               exit
#             end
#           end
#           opts.parse!(argv)
#           result
#         rescue OptionParser::InvalidOption => error
#           puts "#{opts}\n"
#           puts error.message
#           exit
#         end
#       end
#
#     end
#   end
# end