module Socky
  class Connection
    
    attr_accessor :id, :application
    
    # initialize new connection
    # @param [Socky::WebSocket] socket connection Rack env
    def initialize(socket)
      @socket = socket
      @application = Application.find(socket.env)
      
      unless @application.nil?
        @id = self.generate_id
        @application.add_connection(self)
      end
      
      self.send_data(initialization_status)
    end
    
    # return info about connection initialization
    # if successfull then it will return hash with connection id
    # otherwise it will return reson why connecton has failed
    def initialization_status
      if @application && @id
        { 'event' => 'socky:connection_established', 'connection_id' => @id }
      else
        { 'event' => 'socky:error:unknow_application' }
      end
    end
    
    # send data to connection
    # @param [String] data data to send
    def send_data(data)
      @socket.send_data(data)
    end
    
    # remove connection from application
    def destroy
      if @application
        @application.remove_connection(self)
        @application = nil
      end
    end
    
    # generate new id
    # @return [String] connection id
    def generate_id
      @id = Time.now.to_f.to_s.gsub('.', '')
    end
    
  end
end
