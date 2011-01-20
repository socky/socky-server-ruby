require 'spec_helper'

describe Socky do

  context "class" do

    it "should have non-blank version" do
      Socky::VERSION.should_not be_nil
    end
    it "should have options in hash form" do
      Socky.options.should_not be_nil
      Socky.options.class.should eql(Hash)
    end
    it "should allow to set options" do
      Socky.options.should eql(Hash.new)
      begin
        Socky.options = {:key => :value}
        Socky.options.should eql({:key => :value})
      ensure
        Socky.options = Hash.new
      end
    end
    it "should have logger" do
      Socky.logger.should_not be_nil
      Socky.logger.class.should eql(Logger)
    end
    it "should have logger with STDOUT at default" do
      Socky.logger.instance_variable_get('@logdev').dev.class.should eql(IO)
    end
    it "should be able to set logger" do
      begin
        logger = Logger.new(STDOUT)
        Socky.logger.should_not equal(logger)
        Socky.logger = logger
        Socky.logger.should equal(logger)
      ensure
        Socky.logger = nil
      end
    end
    it "should be able to change verbosity of logger by setting debug option" do
      begin
        Socky.logger.level.should eql(Logger::INFO)
        Socky.logger = nil
        Socky.stub!(:options).and_return({:debug => true})
        Socky.logger.level.should eql(Logger::DEBUG)
        Socky.logger = nil
        Socky.stub!(:options).and_return({:debug => false})
        Socky.logger.level.should eql(Logger::INFO)
      ensure
        Socky.logger = nil
      end
    end
    it "should not have default log path" do
      Socky.log_path.should be_nil
    end
    it "should be able to change log path by settion log_path option" do
      Socky.stub!(:options).and_return({:log_path => "abstract"})
      Socky.log_path.should eql("abstract")
    end
    it "should be able to change logger write place" do
      begin
        Socky.options = {:log_path => File.join(File.dirname(__FILE__), 'files', 'socky.log')}
        Socky.logger.should_not be_nil
        Socky.logger.instance_variable_get('@logdev').dev.class.should eql(File)
      ensure
        Socky.logger = nil
        Socky.options = {}
      end
    end
    it "should have default pid path" do
      Socky.pid_path.should_not be_nil
      Socky.pid_path.should eql("/var/run/socky.pid")
    end
    it "should be able to change pid path by settion pid_path option" do
      Socky.stub!(:options).and_return({:pid_path => "abstract"})
      Socky.pid_path.should eql("abstract")
    end
    it "should not have default config path" do
      Socky.config_path.should be_nil
    end
    it "should be able to change config path by settion config_path option" do
      Socky.stub!(:options).and_return({:config_path => "abstract"})
      Socky.config_path.should eql("abstract")
    end

  end

end