require 'spec_helper'

describe Socky::Server::Message do
  
  let(:application) { Socky::Server::Application.new('some_app', 'some_secret') }
  let(:connection) { mock_connection(application.name) }
  let(:channel) { mock(Socky::Server::Channel::Base, :subscribe => nil, :unsubscribe => nil, :deliver => nil) }
  before { Socky::Server::Channel.stub!(:find_or_create).and_return(channel)}
  
  context "#new" do
    it "should get valid instance when json provided" do
      instance = described_class.new(connection, {'event' => 'some_event'}.to_json)
      instance.event.should eql('some_event')
    end
    it "should get empty instance when non-json provided" do
      instance = described_class.new(connection, 'event=some_event')
      instance.event.should eql('')
    end
  end
  
  context "instance" do
    subject { described_class.new( connection, {
                                   'event'   => 'some_event',
                                   'channel' => 'some_channel',
                                   'data'    => 'some_user_data',
                                   'auth'    => 'some_auth',
                                   'read'    => 'read_value',
                                   'write'   => 'write_value',
                                   'hide'    => 'hide_value'
                                 }.to_json)}
  
    its(:event)     { should eql('some_event')     }
    its(:channel)   { should eql('some_channel')   }
    its(:user_data) { should eql('some_user_data') }
    its(:auth)      { should eql('some_auth')      }
    its(:read)      { should eql('read_value')     }
    its(:write)     { should eql('write_value')    }
    its(:hide)      { should eql('hide_value')     }
    
    context "#dispath" do
      it "should call channel.subscribe when 'socky:subscribe' event received" do
        subject.instance_variable_get('@data')['event'] = 'socky:subscribe'
        channel.should_receive(:subscribe).with(connection, subject)
        subject.dispath
      end
      it "should call channel.unsubscribe when 'socky:unsubscribe' event received" do
        subject.instance_variable_get('@data')['event'] = 'socky:unsubscribe'
        channel.should_receive(:unsubscribe).with(connection, subject)
        subject.dispath
      end
      it "should call channel.deliver when normal event received" do
        subject.instance_variable_get('@data')['event'] = 'some_event'
        channel.should_receive(:deliver).with(connection, subject)
        subject.dispath
      end
      it "should not call channel.deliver when unknown socky event received" do
        subject.instance_variable_get('@data')['event'] = 'socky:unknown'
        channel.should_not_receive(:deliver).with(connection, subject)
        subject.dispath
      end
    end
  end
  
end