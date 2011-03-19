require 'spec_helper'

describe 'WebSocket Presence notification' do
    
  before { @application = Socky::Server::Application.new('test_application', 'test_secret')}
  after  { Socky::Server::Application.list.delete(@application.name) }
  
  subject { mock_connection(@application.name) }
  before  { subject.on_open; subject.connection.id = "1234567890" }
  after   { subject.on_close }
  let(:channel_name) { 'presence-test_channel' }
  
  context 'no other users on the same channel' do
    it "should return empty list if no other users are on channel" do
      subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)
    end
    it "should not receive notification about own joining to channel" do
      subject.should_not_receive(:send_data).with(hash_including('event' => 'socky_internal:member:added'))
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)
    end
    it "should not receive notification about own disconnection from channel" do
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)
      subject.should_not_receive(:send_data).with(hash_including('event' => 'socky_internal:member:removed'))
      subject.on_message({ 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
    end
  end
  
  context 'other user on the same channel' do
    let(:other_user) { mock_connection(@application.name) }
    before do
      other_user.on_open
      other_user.connection.id = "123"
      # puts Socky::Authenticator.authenticate({'connection_id' => '123', 'channel' => channel_name}, false, 'test_secret').inspect
      other_user.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
      other_user.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => '64f07ec834bc0f5194a59e6def077cb6:cb26397c9ecde9ec48bf4871b02ad11768a1b0b7828fce030f678aff9653f50b' }.to_json)
    end
    after { other_user.on_close }
    
    it "should return other users list" do
      subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [{"data"=>{}, "connection_id"=>"123"}] })
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)      
    end
    
    it "should send channel join notification to other members" do
      other_user.should_receive(:send_data).with({ 'event' => 'socky_internal:member:added', 'connection_id' => subject.connection.id, 'channel' => channel_name, 'data' => {} })
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)      
    end
    
    it "should send valid user data with join notification" do
      other_user.should_receive(:send_data).with({ 'event' => 'socky_internal:member:added', 'connection_id' => subject.connection.id, 'channel' => channel_name, 'data' => { 'some' => 'data' } })
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => '9a1a526c8025713ab6cc4920cbd72606:330cb64a117f4f1323bc17e58fd870566c29d20dd101edae64c56811169c1b00' }.to_json)
    end
    
    it "should send channel exit notification to other members" do
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => '9a1a526c8025713ab6cc4920cbd72606:330cb64a117f4f1323bc17e58fd870566c29d20dd101edae64c56811169c1b00' }.to_json)
      other_user.should_receive(:send_data).with({ 'event' => 'socky_internal:member:removed', 'connection_id' => subject.connection.id, 'channel' => channel_name })
      subject.on_message({ 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
    end
  end
  
  context 'other user on other channel' do
    let(:other_user) { mock_connection(@application.name) }
    before do
      other_user.on_open
      other_user.connection.id = "123"
      # puts Socky::Authenticator.authenticate({'connection_id' => '123', 'channel' => 'presence-other_channel'}, false, 'test_secret').inspect
      other_user.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => 'presence-other_channel', 'members' => [] })
      other_user.on_message({ 'event' => 'socky:subscribe', 'channel' => 'presence-other_channel', 'auth' => '2f1df408b658c9f3b4aa5717a4e832bd:9df486124b4cd642e3ffb6958cb27582e8cc5c86850ea36e9503d9541d28bd72' }.to_json)
    end
    after { other_user.on_close }
    
    it "should return empty users list" do
      subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)      
    end
    
    it "should not send channel join notification to members on other channels" do
      other_user.should_not_receive(:send_data).with(hash_including('event' => 'socky_internal:member:added'))
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)      
    end
    
    it "should not send channel exit notification to members on other channels" do
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => '9a1a526c8025713ab6cc4920cbd72606:330cb64a117f4f1323bc17e58fd870566c29d20dd101edae64c56811169c1b00' }.to_json)
      other_user.should_not_receive(:send_data).with(hash_including('event' => 'socky_internal:member:removed'))
      subject.on_message({ 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
    end
  end
  
  context 'other user on the same channel but different application' do
    before { @application2 = Socky::Server::Application.new('other_application', 'other_secret')}
    after  { Socky::Server::Application.list.delete(@application2.name) }
    
    let(:other_user) { mock_connection(@application2.name) }
    before do
      pending "reimplement channels!"
      
      other_user.on_open
      other_user.connection.id = "123"
      other_user.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
      other_user.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'b8b574e33669feb9ebaf7ce7702b9de4:d16b7ea7f490d3a6538a35c324f316d650ec23c836d45a9f78596553796d570b' }.to_json)
    end
    after { other_user.on_close }
    
    it "should return empty users list" do
      subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)      
    end
    
    it "should not send channel join notification to members on other channels" do
      other_user.should_not_receive(:send_data).with(hash_including('event' => 'socky_internal:member:added'))
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)      
    end
    
    it "should not send channel exit notification to members on other channels" do
      subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => '9a1a526c8025713ab6cc4920cbd72606:330cb64a117f4f1323bc17e58fd870566c29d20dd101edae64c56811169c1b00' }.to_json)
      other_user.should_not_receive(:send_data).with(hash_including('event' => 'socky_internal:member:removed'))
      subject.on_message({ 'event' => 'socky:unsubscribe', 'channel' => channel_name }.to_json)
    end
  end
    
end