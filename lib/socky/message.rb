require 'json'

module Socky
  # every message from admin is stored as instance of Message
  # and then processed by #process method
  class Message
    include Socky::Misc

    class InvalidJSON < Socky::SockyError; end #:nodoc:
    class UnauthorisedQuery < Socky::SockyError; end #:nodoc:
    class InvalidQuery < Socky::SockyError; end #:nodoc:

    # message params like command type or message content
    attr_reader :params
    # message sender(admin) required when some data are returned
    attr_reader :creator

    class << self
      # create new message and process it
      # @see #process
      # @param [Connection] connection creator of message
      # @param [String] message message content
      def process(connection, message)
        message = new(connection, message)
        message.process
      rescue SockyError => error
        error connection.name, error
        connection.send_message(error.message)
      end
    end

    # initialize new message
    # @param [Connection] creator creator of message
    # @param [String] message valid json containing hash of params
    # @raise [InvalidJSON] if message is invalid json or don't evaluate to hash
    def initialize(creator, message)
      @params = symbolize_keys(JSON.parse(message)) rescue raise(InvalidJSON, "invalid request")
      @creator = creator
    end

    # process message - check command('broadcast' or 'query')
    # and send message to correct connections
    # 'broadcast' command require 'body' of message and allows 'to' and 'except' hashes for filters
    # 'query' command require 'type' of query - currently only 'show_connections' is supported
    # @see Socky::Connection::Finders.find filtering options
    # @raise [InvalidQuery, 'unknown command'] when 'command' param is invalid
    # @raise [InvalidQuery, 'unknown query type'] when 'command' is 'queru' but no 'type' is provided
    def process
      debug [self.name, "processing", params.inspect]

      case params.delete(:command).to_s
        when "broadcast" then broadcast
        when "query" then query
        else raise(InvalidQuery, "unknown command")
      end
    end

    private

    def broadcast
      connections = Socky::Connection.find(params)
      send_message(params[:body], connections)
    end

    def query
      case params[:type].to_s
        when "show_connections" then query_show_connections
        else raise(InvalidQuery, "unknown query type")
      end
    end

    def query_show_connections
      respond Socky::Connection.find_all
    end

    def respond(message)
      creator.send_message(message)
    end

    def send_message(message, connections)
      connections.each{|connection| connection.send_message message}
    end

  end
end