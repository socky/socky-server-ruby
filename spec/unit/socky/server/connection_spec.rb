require 'spec_helper'

describe Socky::Server::Connection do
  
  let(:websocket) { mock_websocket('test_app') }
  before { @application = Socky::Server::Application.new('test_app', 'test_secret') }
  after  { Socky::Server::Application.list.delete(@application.name) }
  
  context "#new" do
    it "should assign valid application" do
      instance = described_class.new(websocket, @application.name)
      instance.application.should eql(@application)
    end
    it "should not assign application if not known" do
      instance = described_class.new(websocket, 'unknown_app')
      instance.application.should eql(nil)
    end
    it "should assign id" do
      instance = described_class.new(websocket, @application.name)
      instance.id.should_not be_nil
    end
    it "should add itself to application connection list" do
      instance = described_class.new(websocket, @application.name)
      @application.connections[instance.id].should equal(instance)
    end
    it "should send initialiation status" do
      websocket.should_receive(:send_data)
      instance = described_class.new(websocket, @application.name)
    end
  end
  
  context "instance" do
    subject { described_class.new(websocket, @application.name) }
    
    its(:channels) { should eql({}) }
    
    context "#initialization_status" do
      it "should return confirmation when application is set" do
        subject.initialization_status.should eql({ 'event' => 'socky:connection:established', 'connection_id' => subject.id })
      end
      it "should return 'unknown app' when application is not set" do
        subject.application = nil
        subject.initialization_status.should eql({ 'event' => 'socky:connection:error', 'reason' => 'refused' })
      end
    end
    
    it "#send_data should send using provided websocket" do
      websocket.should_receive(:send_data).with({:some => 'data'})
      subject.send_data(:some => 'data')
    end
    
    context "#destroy" do
      it "should remove itself from application connection list" do
        subject.destroy
        @application.connections[subject.id].should be_nil
      end
      it "should remove itself from channels list" do
        channels = subject.channels.dup
        subject.destroy
        channels.each do |channel|
          channel.subscribers[subject.id].should be_nil
        end
      end
    end
  end
  
end
