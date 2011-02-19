# module Socky
#   class Connection
#     # finders module - extends Socky::Connection
#     module Finders
#
#       # Return list of all connections
#       def find_all
#         Socky::Connection.connections
#       end
#
#       # Return filtered list of connections
#       # @param [Hash] opts the options for filters.
#       # @option opts [Array] :channels return connections from listed channels
#       # @option opts [Array] :users return connections of listed users
#       # @return [Array] list of connections
#       # @example return all connections
#       #   Socky::Connection.find
#       # @example return no connections
#       #   # empty array as param means "no channels"
#       #   # nil is handles as "ignore param" so all users/channels will be executed
#       #   Socky::Connection.find(:channels => [])
#       #   Socky::Connection.find(:users => [])
#       # @example return connections of users "first" and "second" from channels "some_channel"
#       #   Socky::Connection.find(:channels => "some_channel", :users => ["first","second"])
#       def find(opts = {})
#         connections = find_all
#         connections = filter_by_channels(connections, opts[:channels])
#         connections = filter_by_users(connections, opts[:users])
#
#         connections
#       end
#
#       private
#
#       def filter_by_users(connections, users = nil)
#         # nil means "all users"
#         return connections if users.nil?
#
#         # Empty table means "no users"
#         return [] if users.is_a?(Array) && users.empty?
#
#         users = Array(users)
#
#         connections.find_all do |connection|
#           connection if users.include?(connection.user)
#         end
#       end
#
#       def filter_by_channels(connections, channels = nil)
#         # nil means "all channels"
#         return connections if channels.nil?
#
#         # Empty table means "no channels"
#         return [] if channels.is_a?(Array) && channels.empty?
#
#         channels = Array(channels)
#
#         connections.find_all do |connection|
#           connection unless (connection.channels & channels).empty?
#         end
#       end
#     end
#   end
# end