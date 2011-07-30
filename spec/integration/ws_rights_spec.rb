require 'spec_helper'

describe 'WebSocket Rights' do
  
  before { @application = Socky::Server::Application.new('test_application', 'test_secret')}
  after  { Socky::Server::Application.list.delete('test_application') }
  
  context "connected to application" do
    subject { mock_websocket(@application.name) }
    before  { subject.on_open({'PATH_INFO' => @application.name}); subject.connection.id = "1234567890" }
    after   { subject.on_close({}) }
    
    let(:other_user) do
      return @other_user if defined?(@other_user)
      other = mock_websocket(@application.name)
      other.on_open({'PATH_INFO' => @application.name})
      other.connection.id = "1234567891"
      @other_user = other
    end
    after { @other_user.on_close({}) if defined?(@other_user) }
    
    context "public channel" do
      let(:channel_name) { 'test_channel' }
      
      it "should not be able to disable read permission" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name })
        Socky::Server::Channel.find_or_create(@application.name, channel_name).send_data({ 'event' => 'test_event', 'channel' => channel_name })
      end
      
      it "should not be able to enable write permission" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true }.to_json)
        subject.should_not_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name })
        other_user.on_message({}, { 'event' => 'test_event', 'channel' => channel_name }.to_json)
      end
    end
    
    context "private channel" do
      let(:channel_name) { 'private-test_channel' }
      
      it "should be able to disable read permission" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => auth_token(subject, channel_name, 'read' => false) }.to_json)
        subject.should_not_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name })
        Socky::Server::Channel.find_or_create(@application.name, channel_name).send_data({ 'event' => 'test_event', 'channel' => channel_name })
      end
            
      it "should be able to enable write pemission" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => auth_token(subject, channel_name) }.to_json)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => auth_token(other_user, channel_name, 'write' => true) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name, 'data' => nil })
        other_user.on_message({}, { 'event' => 'test_event', 'channel' => channel_name }.to_json)
      end
      
      it "should still send messages with read permission disabled" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => auth_token(subject, channel_name) }.to_json)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'write' => true, 'auth' => auth_token(other_user, channel_name, 'read' => false, 'write' => true) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name, 'data' => nil })
        other_user.on_message({}, { 'event' => 'test_event', 'channel' => channel_name }.to_json)
      end
      
      it "should still receive messages with write permission disabled" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => false, 'auth' => auth_token(subject, channel_name, 'write' => false) }.to_json)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => auth_token(other_user, channel_name, 'write' => true) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name, 'data' => nil })
        other_user.on_message({}, { 'event' => 'test_event', 'channel' => channel_name }.to_json)
      end
    end
    
    context "presence channel" do
      let(:channel_name) { 'presence-test_channel' }
      
      it "should be able to disable read permission" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => auth_token(subject, channel_name, 'read' => false) }.to_json)
        subject.should_not_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name })
        Socky::Server::Channel.find_or_create(@application.name, channel_name).send_data({ 'event' => 'test_event', 'channel' => channel_name })
      end
      
      it "should still send messages with read permission disabled" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => auth_token(subject, channel_name) }.to_json)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'write' => true, 'auth' => auth_token(other_user, channel_name, 'read' => false, 'write' => true) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name, 'data' => nil })
        other_user.on_message({}, { 'event' => 'test_event', 'channel' => channel_name }.to_json)
      end
      
      it "should not receive members notification with read permission disabled" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => auth_token(subject, channel_name, 'read' => false) }.to_json)
        subject.should_not_receive(:send_data)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => auth_token(other_user, channel_name) }.to_json)
      end
      
      it "should be able to enable write pemission" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => auth_token(subject, channel_name) }.to_json)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => auth_token(other_user, channel_name, 'write' => true) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name, 'data' => nil })
        other_user.on_message({}, { 'event' => 'test_event', 'channel' => channel_name }.to_json)
      end
      
      it "should still receive messages with write permission disabled" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => false, 'auth' => auth_token(subject, channel_name, 'write' => false) }.to_json)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => auth_token(other_user, channel_name, 'write' => true) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name, 'data' => nil })
        other_user.on_message({}, { 'event' => 'test_event', 'channel' => channel_name }.to_json)
      end
      
      it "should still send members notification with write permission disabled" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => auth_token(subject, channel_name) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'socky:member:added', 'channel' => channel_name, 'connection_id' => other_user.connection.id, 'data' => {} })
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => false, 'auth' => auth_token(other_user, channel_name, 'write' => false) }.to_json)
      end
      
      it "should be able to enable hide permission" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => auth_token(subject, channel_name) }.to_json)
        subject.should_not_receive(:send_data).with({ 'event' => 'socky:member:added', 'channel' => channel_name, 'connection_id' => other_user.connection.id, 'data' => {} })
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'hide' => true, 'auth' => auth_token(other_user, channel_name, 'hide' => true) }.to_json)
      end
      
      it "should still receive messages with hide permission enabled" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'hide' => true, 'auth' => auth_token(subject, channel_name, 'hide' => true) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name })
        Socky::Server::Channel.find_or_create(@application.name, channel_name).send_data({ 'event' => 'test_event', 'channel' => channel_name })
      end
      
      it "should be able to send messages whild hide permission is enabled" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => auth_token(subject, channel_name) }.to_json)
        other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'hide' => true, 'auth' => auth_token(other_user, channel_name, 'write' => true, 'hide' => true) }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'test_event', 'channel' => channel_name, 'data' => nil })
        other_user.on_message({}, { 'event' => 'test_event', 'channel' => channel_name }.to_json)
      end
    end
  end
  
end