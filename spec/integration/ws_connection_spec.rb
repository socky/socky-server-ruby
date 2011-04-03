require 'spec_helper'

describe 'WebSocket Connection' do
  
  before { @application = Socky::Server::Application.new('test_application', 'test_secret')}
  after  { Socky::Server::Application.list.delete('test_application') }
  
  context 'Valid application' do
    subject { mock_websocket(@application.name) }
    
    it "should receive confirmation on connection" do
      subject.should_receive(:send_data).with(hash_including( 'event' => 'socky:connection:established' ))
      subject.on_open({'PATH_INFO' => @application.name})
    end
        
    it "should generate connection" do
      subject.on_open({'PATH_INFO' => @application.name})
      subject.connection.should_not be_nil
      subject.connection.class.should eql(Socky::Server::Connection)
    end
    
    it "should not close connection" do
      subject.should_not_receive(:on_close)
      subject.on_open({'PATH_INFO' => @application.name})
    end
  end
  
  context "Invalid application" do
    subject { mock_websocket('invalid_name') }
    
    it "should receive 'application invalid' error" do
      subject.should_receive(:send_data).with({ 'event' => 'socky:connection:error', 'reason' => 'refused' })
      subject.on_open({'PATH_INFO' => 'invalid_name'})
    end
        
    it "should generate connection" do
      subject.on_open({'PATH_INFO' => 'invalid_name'})
      subject.connection.should_not be_nil
      subject.connection.class.should eql(Socky::Server::Connection)
    end
    
    it "should close connection" do
      subject.should_receive(:on_close)
      subject.on_open({'PATH_INFO' => 'invlaid_name'})
    end
  end
  
end