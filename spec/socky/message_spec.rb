# require 'spec_helper'
#
# describe Socky::Message do
#   before(:each) do
#     @connection = mock(:connection, :name => "connection", :send_message => nil)
#   end
#
#   context "class" do
#     context "#process" do
#       before(:each) { @message = mock(:message, :process => nil) }
#       it "should create new instance of self with provided params" do
#         described_class.stub!(:new).and_return(@message)
#         described_class.should_receive(:new).with(@connection, "test")
#         described_class.process(@connection, "test")
#       end
#       it "should send #process to instance if valid message" do
#         described_class.stub!(:new).and_return(@message)
#         @message.should_receive(:process)
#         described_class.process(@connection, "test")
#       end
#       it "should rescue from error if creating instance raise error" do
#         described_class.stub!(:new).and_raise(Socky::SockyError)
#         lambda{ described_class.process(@connection, "test") }.should_not raise_error
#       end
#       it "should rescue from error if parsing instance raise error" do
#         @message.stub!(:process).and_raise(Socky::SockyError)
#         described_class.stub!(:new).and_return(@message)
#         lambda{ described_class.process(@connection, "test") }.should_not raise_error
#       end
#     end
#     context "#new" do
#       it "should create message with provided creator and message is message is JSON hash" do
#         message = described_class.new(@connection, {:test => true}.to_json)
#         message.params.should eql(:test => true)
#         message.creator.should eql(@connection)
#       end
#       it "should raise error if message is not JSON" do
#         lambda{described_class.new(@connection, {:test => true})}.should raise_error Socky::SockyError
#         lambda{described_class.new(@connection, "test")}.should raise_error Socky::SockyError
#       end
#       it "should raise error if message is JSON but not JSON hash" do
#         lambda{described_class.new(@connection, "test".to_json)}.should raise_error Socky::SockyError
#       end
#     end
#   end
#
#   context "instance" do
#     before(:each) { @message = described_class.new(@connection, {}.to_json) }
#     context "#process" do
#       before(:each) do
#         @message.stub!(:send_message)
#       end
#       it "should raise error if message command is nil" do
#         @message.stub!(:params).and_return({:cmd => nil})
#         lambda {@message.process}.should raise_error(Socky::SockyError, "unknown command")
#       end
#       it "should raise error if message command is neither :broadcast nor :query" do
#         @message.stub!(:params).and_return({:cmd => :invalid})
#         lambda {@message.process}.should raise_error(Socky::SockyError, "unknown command")
#       end
#       it "should not distinguish between string and symbol in command" do
#         @message.stub!(:params).and_return({:cmd => 'b'})
#         lambda {@message.process}.should_not raise_error(Socky::SockyError, "unknown command")
#       end
#       context ":broadcast" do
#         it "should select target connections basing on params" do
#           @message.stub!(:params).and_return({:cmd => 'b', :c => :chan, :u => :usr})
#           Socky::Connection.should_receive(:find).with(:channels => :chan, :users => :usr)
#           @message.process
#         end
#         it "should send_message with message body and connection list" do
#           @message.stub!(:params).and_return({:cmd => 'b', :d => "some message"})
#           Socky::Connection.stub!(:find).and_return(["first","second"])
#           @message.should_receive(:send_message).with("some message", ["first", "second"])
#           @message.process
#         end
#       end
#       context ":query" do
#         it "should raise error if query type is nil" do
#           @message.stub!(:params).and_return(:cmd => 'q', :d => nil)
#           lambda{ @message.process }.should raise_error(Socky::SockyError, "unknown query type")
#         end
#         it "should raise error if query type is invalid" do
#           @message.stub!(:params).and_return(:cmd => 'q', :d => :invalid)
#           lambda{ @message.process }.should raise_error(Socky::SockyError, "unknown query type")
#         end
#         it "should not distinguish between string and symbol in command" do
#           @message.stub!(:params).and_return({:cmd => 'q', :d => "show_connections"})
#           lambda {@message.process}.should_not raise_error(Socky::SockyError, "unknown query type")
#         end
#         context "=> :show_connections" do
#           it "should return current connection list to creator" do
#             @message.stub!(:params).and_return(:cmd => 'q', :d => :show_connections)
#             Socky::Connection.stub!(:find_all).and_return(["find results"])
#             @connection.should_receive(:send_message).with(["find results"])
#             @message.process
#           end
#         end
#       end
#     end
#   end
# end