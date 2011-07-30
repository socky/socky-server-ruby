require 'spec_helper'

describe 'WebSocket Presence notification' do
    
  before { @application = Socky::Server::Application.new('test_application', 'test_secret')}
  after  { Socky::Server::Application.list.delete(@application.name) }
  
  subject { mock_websocket(@application.name) }
  before  { subject.on_open({'PATH_INFO' => @application.name}); subject.connection.id = "1234567890" }
  after   { subject.on_close({}) }
  let(:channel_name) { 'presence-test_channel' }
  
  context 'no other users on the same channel' do
    it "should return empty list if no other users are on channel" do
      subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)
    end
    it "should not receive notification about own joining to channel" do
      subject.should_not_receive(:send_data).with(hash_including('event' => 'socky:member:added'))
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)
    end
    it "should not receive notification about own disconnection from channel" do
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)
      subject.should_not_receive(:send_data).with(hash_including('event' => 'socky:member:removed'))
      subject.on_message({}, { 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
    end
  end
  
  context 'other user on the same channel' do
    let(:other_user) { mock_websocket(@application.name) }
    before do
      other_user.on_open({'PATH_INFO' => @application.name})
      other_user.connection.id = "123"
      other_user.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
      other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:2ed67632bf9a03e7e28068284efae222256f80dfafe798abff85455401d6000e' }.to_json)
    end
    after { other_user.on_close({}) }
    
    it "should return other users list" do
      subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [{"data"=>{}, "connection_id"=>"123"}] })
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)      
    end
    
    it "should send channel join notification to other members" do
      other_user.should_receive(:send_data).with({ 'event' => 'socky:member:added', 'connection_id' => subject.connection.id, 'channel' => channel_name, 'data' => {} })
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)      
    end
    
    it "should send valid user data with join notification" do
      other_user.should_receive(:send_data).with({ 'event' => 'socky:member:added', 'connection_id' => subject.connection.id, 'channel' => channel_name, 'data' => { 'some' => 'data' } })
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:9cdbfc5746f67c26784f75683a0f89a70f6079f0030f48ac8193458717f0791e' }.to_json)
    end
    
    it "should send channel exit notification to other members" do
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:9cdbfc5746f67c26784f75683a0f89a70f6079f0030f48ac8193458717f0791e' }.to_json)
      other_user.should_receive(:send_data).with({ 'event' => 'socky:member:removed', 'connection_id' => subject.connection.id, 'channel' => channel_name })
      subject.on_message({}, { 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
    end
  end
  
  context 'other user on other channel' do
    let(:other_user) { mock_websocket(@application.name) }
    before do
      other_user.on_open({'PATH_INFO' => @application.name})
      other_user.connection.id = "123"
      other_user.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => 'presence-other_channel', 'members' => [] })
      other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => 'presence-other_channel', 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:6861bcb873a4a9c4bcd6b7fc1bf3b170684f191ebbdb1e222614900c9243a0fa' }.to_json)
    end
    after { other_user.on_close({}) }
    
    it "should return empty users list" do
      subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)      
    end
    
    it "should not send channel join notification to members on other channels" do
      other_user.should_not_receive(:send_data).with(hash_including('event' => 'socky:member:added'))
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)      
    end
    
    it "should not send channel exit notification to members on other channels" do
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:9cdbfc5746f67c26784f75683a0f89a70f6079f0030f48ac8193458717f0791e' }.to_json)
      other_user.should_not_receive(:send_data).with(hash_including('event' => 'socky:member:removed'))
      subject.on_message({}, { 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
    end
  end
  
  context 'other user on the same channel but different application' do
    before { @application2 = Socky::Server::Application.new('other_application', 'other_secret')}
    after  { Socky::Server::Application.list.delete(@application2.name) }
    
    let(:other_user) { mock_websocket(@application2.name) }
    before do
      other_user.on_open({'PATH_INFO' => @application2.name})
      other_user.connection.id = "123"
      other_user.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
      other_user.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:5667cf407419d95a042e4e0479f25fa4b62ed548285e80db0af0fc5262ea60c6' }.to_json)
    end
    after { other_user.on_close({}) }
    
    it "should return empty users list" do
      subject.should_receive(:send_data).with({ 'event' => 'socky:subscribe:success', 'channel' => channel_name, 'members' => [] })
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)      
    end
    
    it "should not send channel join notification to members on other channels" do
      other_user.should_not_receive(:send_data).with(hash_including('event' => 'socky:member:added'))
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:72fa6a183de7aa0dbeb10db03daec3d6e9fb590c38fc1b6aee0bc69a585c16ee' }.to_json)      
    end
    
    it "should not send channel exit notification to members on other channels" do
      subject.on_message({}, { 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:9cdbfc5746f67c26784f75683a0f89a70f6079f0030f48ac8193458717f0791e' }.to_json)
      other_user.should_not_receive(:send_data).with(hash_including('event' => 'socky:member:removed'))
      subject.on_message({}, { 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
    end
  end
    
end