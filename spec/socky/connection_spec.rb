require 'spec_helper'

describe Socky::Connection do

  context "class" do
    it "should have connections array" do
      described_class.connections.should_not be_nil
      described_class.connections.class.should eql(Array)
    end
    it "should have empty connections array at start" do
      described_class.connections.should be_empty
    end
    it "should create instance and assign socket to self" do
      socket = mock(:socket)
      connection = described_class.new(socket)
      connection.socket.should equal(socket)
    end
  end

  context "instance" do
    before(:each) do
      described_class.connections.clear
      socket = mock(:socket, :request => { "Query" => {}})
      @connection = described_class.new(socket)
    end

    context "#admin" do
      it "should return true for socket request data admin equal to '1' and 'true'" do
        ["1","true"].each do |value|
          @connection.socket.request["Query"]["admin"] = value
          @connection.admin.should be_true
        end
      end
      it "should return false for socket request data admin equal to anything except '1' and 'true'" do
        [nil,"0","false","abstract"].each do |value|
          @connection.socket.request["Query"]["admin"] = value
          @connection.admin.should be_false
        end
      end
      it "should return false if socket request data is nil" do
        @connection.socket.request["Query"] = nil
        @connection.admin.should be_false
      end
    end
    it "#user should return user_id from socket request data" do
      @connection.socket.request["Query"]["user_id"] = "abstract"
      @connection.user.should eql("abstract")
    end
    it "#secret should return user_secret from socket request data" do
      @connection.socket.request["Query"]["user_secret"] = "abstract"
      @connection.secret.should eql("abstract")
    end
    context "#channels" do
      it "should ba array" do
        @connection.channels.should_not be_nil
        @connection.channels.class.should eql(Array)
      end
      it "should return table with nil if socket request data 'channels' is nil" do
        @connection.socket.request["Query"]["channels"] = nil
        @connection.channels.should eql([nil])
      end
      it "should return table of channels if provided and separated by comma" do
        @connection.socket.request["Query"]["channels"] = "aaa,bbb,ccc"
        @connection.channels.should eql(["aaa","bbb","ccc"])
      end
      it "should not allow empty names of channels" do
        @connection.socket.request["Query"]["channels"] = "aaa,,ccc"
        @connection.channels.should eql(["aaa","ccc"])
      end
      it "should strip trailing spaces in channel names" do
        @connection.socket.request["Query"]["channels"] = "  aaa\n  , \n , ccc  "
        @connection.channels.should eql(["aaa","ccc"])
      end
    end
    it "#subscribe should send subscribe request" do
      @connection.stub!(:subscribe_request)
      @connection.should_receive(:subscribe_request)
      @connection.subscribe
    end
    it "#unsubscribe should send unsubscribe request" do
      @connection.stub!(:unsubscribe_request)
      @connection.should_receive(:unsubscribe_request)
      @connection.unsubscribe
    end
    context "#process_message" do
      it "should send process request to socky message class if connection is by admin" do
        @connection.stub!(:admin).and_return(true)
        Socky::Message.stub!(:process)
        Socky::Message.should_receive(:process).with(@connection, "abstract")
        @connection.process_message("abstract")
      end
      it "should send user message that he can not send messages if connection is not admin" do
        @connection.stub!(:admin).and_return(false)
        @connection.stub!(:send_message)
        @connection.should_receive(:send_message).with("You are not authorized to post messages")
        @connection.process_message("abstract")
      end
    end
    it "#send_message should call #send_data with hashed form of message" do
      @connection.should_receive(:send_data).with({:type => :message, :body => "abstract"})
      @connection.send_message("abstract")
    end
    it "#send_data should send message by socket in json format" do
      @connection.socket.stub!(:send)
      @connection.socket.should_receive(:send).with({:test => "abstract"}.to_json)
      @connection.send(:send_data, {:test => "abstract"})
    end
    it "#disconnect should close connection after writing" do
      @connection.socket.stub!(:close_connection_after_writing)
      @connection.socket.should_receive(:close_connection_after_writing)
      @connection.disconnect
    end
    context "#add_to_pool" do
      it "should add self to class connection list if self isn't already on list or self isn't admin" do
        @connection.stub!(:admin).and_return(false)
        @connection.send(:add_to_pool)
        described_class.connections.should include(@connection)
        described_class.connections.should have(1).item
      end
      it "should not add self to class connection list if self is already on it" do
        described_class.connections << @connection
        described_class.connections.should have(1).item
        @connection.stub!(:admin).and_return(false)
        @connection.send(:add_to_pool)
        described_class.connections.should include(@connection)
        described_class.connections.should have(1).item
      end
      it "should not add self to class connection list if self is admin" do
        @connection.stub!(:admin).and_return(true)
        @connection.send(:add_to_pool)
        described_class.connections.should_not include(@connection)
      end
    end
    it "#remove_from_pool should delete self from class connection list" do
      described_class.connections << @connection
      described_class.connections.should have(1).item
      @connection.send(:remove_from_pool)
      described_class.connections.should_not include(@connection)
      described_class.connections.should have(0).items
    end
    it "#to_json should return self as hash of object_id, user_id and channels" do
      @connection.socket.request["Query"]["user_id"] = "abstract"
      @connection.socket.request["Query"]["channels"] = "first,second,third"
      json = @connection.to_json
      JSON.parse(json).should eql({ "id" => @connection.object_id,
                                    "user_id" => @connection.user,
                                    "channels" => @connection.channels})
    end
  end

end