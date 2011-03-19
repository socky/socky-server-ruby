require 'spec_helper'

describe 'WebSocket Channels' do
  
  before { @application = Socky::Server::Application.new('test_application', 'test_secret')}
  after  { Socky::Server::Application.list.delete('test_application') }
  
  context "connected to application" do
    subject { mock_connection(@application.name) }
    before  { subject.on_open; subject.connection.id = "1234567890" }
    after   { subject.on_close }
    
    context "public channel" do
      let(:channel_name) { 'test_channel' }
      
      it "should be able to join without auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
      end
    
      it "should have channel on his list after auth" do
        subject.connection.channels[channel_name].should be_nil
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
        subject.connection.channels[channel_name].should_not be_nil
      end
    end
    
    context "private channel" do
      let(:channel_name) { 'private-test_channel' }
      
      it "should not be able to join without auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
      end
      
      it "should not be able to join with invalid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'invalid' }.to_json)
      end
      
      it "should be able to join with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'afdc07ceaa841db71d0d01fb2b17850b:d77b99ea70fdb487a8d6d4279cea37199b991f7fed9dd8be900c8451b344cb18' }.to_json)
      end
      
      it "should require modified auth to join with changing read rights" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => 'afdc07ceaa841db71d0d01fb2b17850b:d77b99ea70fdb487a8d6d4279cea37199b991f7fed9dd8be900c8451b344cb18' }.to_json)
      end
      
      it "should allow changing read rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => '6e039ada5575795e53c382ba316ceb5f:18e4bb05c33e89ca446ac5d5c30dacfb7e2b81bb08ff342cd1ed5013a94549bf' }.to_json)
      end
      
      it "should require modified auth to join with changing write rights" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => 'afdc07ceaa841db71d0d01fb2b17850b:d77b99ea70fdb487a8d6d4279cea37199b991f7fed9dd8be900c8451b344cb18' }.to_json)
      end
      
      it "should allow changing read rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => '94eebeb7b285adaf303d3644aedad77e:69943f47af7a051a75d17ea06ef00aceb8511f446d4e0dc9ef7b55cb2ea85634' }.to_json)
      end
      
      it "should ignore changing hide right" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'hide' => true, 'auth' => 'afdc07ceaa841db71d0d01fb2b17850b:d77b99ea70fdb487a8d6d4279cea37199b991f7fed9dd8be900c8451b344cb18' }.to_json)
      end
    end
    
    context "presence channel" do
      let(:channel_name) { 'presence-test_channel' }
      
      it "should not be able to join without auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name }.to_json)
      end
      
      it "should not be able to join with invalid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'invalid' }.to_json)
      end
      
      it "should be able to join with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)
      end
      
      it "should require modified auth to join with changing read rights" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)
      end
      
      it "should allow changing read rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'read' => false, 'auth' => '432dd5e19710741c86f5d4df11ae49b8:d009971a8445ff099f43589743ce80f45257cf05d9795f2c87e801f50961fcb3' }.to_json)
      end
      
      it "should require modified auth to join with changing write rights" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)
      end
      
      it "should allow changing read rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'write' => true, 'auth' => '301a58a715be720051a696bd023ebee9:2a9c935303ed815ba0f9ea8c903a7848a28f6960a9db757dad5255fdff2db976' }.to_json)
      end
      
      it "should require modified auth to join with changing hide right" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'hide' => true, 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)
      end
      
      it "should allow changing hide rights with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'hide' => true, 'auth' => '46529099f37bcb5eea247c40571761d7:84c852c9f119918d975024da59be55d09523c81d93c0376034d49ff7054e9d65' }.to_json)
      end
      
      it "should require changing auth after changind user data" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:failure', 'channel' => channel_name })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => 'ec7ca4b2d08958ad7f98bb5df4f63c5c:3546436fefe10ee4dfe752d3f11d758dc57b9dc043cf3f2ff9854d2d89c21d1d' }.to_json)
      end
      
      it "should allow passing user data with valid auth" do
        subject.should_receive(:send_data).with({ 'event' => 'socky_internal:subscribe:success', 'channel' => channel_name, 'members' => [] })
        subject.on_message({ 'event' => 'socky:subscribe', 'channel' => channel_name, 'data' => "{\"some\":\"data\"}", 'auth' => '9a1a526c8025713ab6cc4920cbd72606:330cb64a117f4f1323bc17e58fd870566c29d20dd101edae64c56811169c1b00' }.to_json)
      end
    end
  end
  
end