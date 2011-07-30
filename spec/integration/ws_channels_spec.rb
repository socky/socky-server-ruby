require 'spec_helper'

describe 'WebSocket Channels' do
  
  before { @application = Socky::Server::Application.new('test_application', 'test_secret')}
  after  { Socky::Server::Application.list.delete('test_application') }
  
  context "connected to application" do
    subject { mock_websocket(@application.name) }
    before  { subject.on_open({'PATH_INFO' => @application.name}); subject.connection.id = "1234567890" }
    after   { subject.on_close({}) }
    
    context "public channel" do
      let(:channel_name) { 'test_channel' }
      
      it "should be able to join without auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
      end
    
      it "should have channel on his list after auth" do
        subject.connection.channels[channel_name].should be_nil
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
        subject.connection.channels[channel_name].should_not be_nil
      end
      
      it "should allow unsubscribing from channel" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
        subject.should_receive(:send_data).with({ 'event' => 'socky:unsubscribe:success', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
      end
      
      it "should not have channel on his list after unsubscribing" do
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
        subject.on_message({}, { 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
        subject.connection.channels[channel_name].should be_nil
      end
    end
    
    context "private channel" do
      let(:channel_name) { 'private-test_channel' }
      
      it "should not be able to join without auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
      end
      
      it "should not be able to join with invalid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'invalid' }.to_json)
      end
      
      it "should be able to join with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'afdc07ceaa841db71d0d01fb2b17850b:d77b99ea70fdb487a8d6d4279cea37199b991f7fed9dd8be900c8451b344cb18' }.to_json)
      end
      
      it "should require modified auth to join with changing read rights" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => 'afdc07ceaa841db71d0d01fb2b17850b:d77b99ea70fdb487a8d6d4279cea37199b991f7fed9dd8be900c8451b344cb18' }.to_json)
      end
      
      it "should allow changing read rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => '6e039ada5575795e53c382ba316ceb5f:18e4bb05c33e89ca446ac5d5c30dacfb7e2b81bb08ff342cd1ed5013a94549bf' }.to_json)
      end
      
      it "should require modified auth to join with changing write rights" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => 'afdc07ceaa841db71d0d01fb2b17850b:d77b99ea70fdb487a8d6d4279cea37199b991f7fed9dd8be900c8451b344cb18' }.to_json)
      end
      
      it "should allow changing read rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => '94eebeb7b285adaf303d3644aedad77e:69943f47af7a051a75d17ea06ef00aceb8511f446d4e0dc9ef7b55cb2ea85634' }.to_json)
      end
      
      it "should ignore changing hide right" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'hide' => true, 'auth' => 'afdc07ceaa841db71d0d01fb2b17850b:d77b99ea70fdb487a8d6d4279cea37199b991f7fed9dd8be900c8451b344cb18' }.to_json)
      end
    end
    
    context "presence channel" do
      let(:channel_name) { 'presence-test_channel' }
      
      it "should not be able to join without auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
      end
      
      it "should not be able to join with invalid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'invalid' }.to_json)
      end
      
      it "should be able to join with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)
      end
      
      it "should require modified auth to join with changing read rights" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)
      end
      
      it "should allow changing read rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:cb123cdaf630653a61b7cd03941847a9a49d45d88d6c61f9858fb9754f7ad40a' }.to_json)
      end
      
      it "should require modified auth to join with changing write rights" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)
      end
      
      it "should allow changing read rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:d7c118d5dad01318c8be2f96bd00e2d3f13bf2893270fd60d92c89027c78e035' }.to_json)
      end
      
      it "should require modified auth to join with changing hide right" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'hide' => true, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)
      end
      
      it "should allow changing hide rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'hide' => true, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:2f8dfc64afdd0acc59f690f45d24b48d40fb9859dbe7dc39677b60457a64739c' }.to_json)
      end
      
      it "should require changing auth after changind user data" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:failure', 'channel' => channel_name })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)
      end
      
      it "should allow passing user data with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:9cdbfc5746f67c26784f75683a0f89a70f6079f0030f48ac8193458717f0791e' }.to_json)
      end
    end
  end
  
end