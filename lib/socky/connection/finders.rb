module Socky
  class Connection
    # finders module - extends Socky::Connection
    module Finders

      # Return list of all connections
      def find_all
        Socky::Connection.connections
      end

      # Return filtered list of connections
      # @param [Hash] opts the options for filters.
      # @option opts [Hash] :to ({}) return only listed clients/channels. keys supported: clients, channels
      # @option opts [Hash] :except ({}) return all clients/channels except listed. keys supported: clients, channels
      # @return [Array] list of connections
      # @example return all connections
      #   Socky::Connection.find
      # @example return no connections
      #   # empty array as param means "no channels"
      #   # nil is handles as "ignore param" so all clients/channels will be executed
      #   Socky::Connection.find(:to => { :clients => [] })
      #   Socky::Connection.find(:to => { :channels => [] })
      # @example return connections of users "first" and "second" from channels "some_channel"
      #   Socky::Connection.find(:to => { :clients => ["first","second"], :channels => "some_channel" })
      # @example return all connections from channel "some_channel" except of ones belonging to "first"
      #   Socky::Connection.find(:to => { :channels => "some_channel" }, :except => { :clients => "first" })
      def find(opts = {})
        to = symbolize_keys(opts[:to]) || {}
        exclude = symbolize_keys(opts[:except]) || {}

        connections = find_all
        connections = filter_by_clients(connections, to[:clients], exclude[:clients])
        connections = filter_by_channels(connections, to[:channels], exclude[:channels])

        connections
      end

      private

      def filter_by_clients(connections, included_clients = nil, excluded_clients = nil)
        # Empty table means "no users" - nil means "all users"
        return [] if (included_clients.is_a?(Array) && included_clients.empty?)

        included_clients = Array(included_clients)
        excluded_clients = Array(excluded_clients)

        connections.find_all do |connection|
          connection if (included_clients.empty? || included_clients.include?(connection.client)) && !excluded_clients.include?(connection.client)
        end
      end

      def filter_by_channels(connections, included_channels = nil, excluded_channels = nil)
        # Empty table means "no channels" - nil means "all channels"
        return [] if (included_channels.is_a?(Array) && included_channels.empty?)

        included_channels = Array(included_channels)
        excluded_channels = Array(excluded_channels)

        connections.find_all do |connection|
          connection if connection.channels.any? do |channel|
            (included_channels.empty? || included_channels.include?(channel) ) && !excluded_channels.include?(channel)
          end
        end
      end
    end
  end
end