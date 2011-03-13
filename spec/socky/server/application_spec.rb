require 'spec_helper'

describe Socky::Server::Application do
  
  context "#list" do
    it "should be empty hash at default" do
      described_class.list.class.should eql(Hash)
      described_class.list.keys.should be_empty
    end
  end
  
  context "#find" do
    it "should return nil if provided application doesn't exists" do
      described_class.find('invalid').should be_nil
    end
    it "should return application if exists" do
      begin
        instance = described_class.new('some_app', 'some_secret')
        described_class.find('some_app').should equal(instance)
      ensure
        described_class.list.delete('some_app')
      end
    end
  end
  
  context "#new" do
    it "should save gived application on list" do
      instance = described_class.new('some_app', 'some_secret')
      described_class.list.delete('some_app').should equal(instance)
    end
    it "should not duplicate already exisiting apps" do
      instance1 = described_class.new('some_app', 'some_secret')
      instance2 = described_class.new('some_app', 'some_other_secret')
      described_class.list.delete('some_app').should equal(instance1)
      described_class.list.keys.should be_empty
    end
  end
  
  context "instance" do
    subject { described_class.new('some_app', 'some_secret') }
    
    its(:name) { should eql('some_app') }
    its(:secret) { should eql('some_secret') }
    its(:connections) { should eql({}) }
    
    let(:connection) { mock(Socky::Server::Connection, :id => 'some_id') }
    
    it "should be able to add connection to list" do
      subject.add_connection(connection)
      subject.connections[connection.id].should equal(connection)
    end
    it "should be able to remove connection from list" do
      subject.add_connection(connection)
      subject.connections[connection.id].should equal(connection)
      subject.remove_connection(connection)
      subject.connections[connection.id].should be_nil
    end
  end
  
end