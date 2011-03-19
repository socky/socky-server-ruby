require 'spec_helper'

describe Socky::Server::Config do
  
  context "#debug" do
    it "should enable logger when true provided" do
      Socky::Server::Logger.should_receive(:enabled=).with(true)
      described_class.new(:debug => true)
    end
    it "should disable logger when false provided" do
      Socky::Server::Logger.should_receive(:enabled=).with(false)
      described_class.new(:debug => false)
    end
  end
  
  context "#applications" do
    it "should raise if param is not hash" do
      lambda { described_class.new(:applications => "invalid") }.should raise_error ArgumentError, 'expected Hash'
    end
    it "should create application if hash provided" do
      Socky::Server::Application.should_receive(:new).with('test_app','test_secret')
      described_class.new(:applications => {'test_app' => 'test_secret'})
    end
    it "should convert application name to string if provided in other type" do
      Socky::Server::Application.should_receive(:new).with('1','test_secret')
      described_class.new(:applications => {1 => 'test_secret'})
    end
    it "should convert application secret to string if provided in other type" do
      Socky::Server::Application.should_receive(:new).with('test_app','1')
      described_class.new(:applications => {'test_app' => 1})
    end
  end
  
  context "#config_file" do
    it "should raise if non-string provided" do
      lambda { described_class.new(:config_file => 123) }.should raise_error ArgumentError, 'expected String'
    end
    it "should raise if provided file doesn't exists" do
      lambda { described_class.new(:config_file => 'invalid.yml') }.should raise_error ArgumentError, 'config file not found: invalid.yml'
    end
    it "should raise on invalid config file" do
      lambda { described_class.new(:config_file => File.expand_path(__FILE__)) }.should raise_error ArgumentError, 'invalid config file'
    end
    it "should read example config file and set attributes" do
      Socky::Server::Logger.should_receive(:enabled=).with(true)
      Socky::Server::Application.should_receive(:new).with('some_test_app','some_test_secret')
      described_class.new(:config_file => File.expand_path(File.dirname(__FILE__)) + '/../../../fixtures/example_config.yml')
    end
  end
end