require 'spec_helper'

describe Socky::Runner do
  
  context "#class" do
    context "#run" do
      before(:each) do
        @server = mock(:server, :start => nil)
        described_class.stub!(:new).and_return(@server)
      end
      it "should create new instance of self" do
        described_class.should_receive(:new).with("some args")
        described_class.run("some args")
      end
      it "should call #start on new instance of self if daemonize option is false" do
        Socky.stub(:options).and_return({:daemonize => false})
        @server.should_receive(:start)
        described_class.run
      end
      it "should call #daemonize on new instance of self if daemonize option is true" do
        Socky.stub(:options).and_return({:daemonize => true})
        @server.should_receive(:daemonize)
        described_class.run
      end
      it "should call #kill_pid on new instance of self if kill option is true" do
        Socky.stub(:options).and_return({:kill => true})
        @server.should_receive(:kill_pid)
        described_class.run
      end
    end
    context "#new" do
      it "should prepare options from args" do
        begin
          described_class.new(["-c", File.dirname(__FILE__) + "/../files/default.yml"])
          Socky.options.class.should eql(Hash)
          Socky.options.should_not be_empty
        ensure
          Socky.options = nil
        end
      end
    end
  end
  
  context "#instance" do
    before(:each) do
      Socky::Options.stub!(:prepare)
      @runner = described_class.new
    end
    
    context "#start" do
      it "should create valid websocket server" do
        begin
          EM.run do
            MSG = "Hello World!"
            EventMachine.add_timer(0.1) do
              http = EventMachine::HttpRequest.new('ws://127.0.0.1:12345/').get :timeout => 0
              http.errback {
                EM.stop
                fail
              }
              http.callback {
                http.response_header.status.should == 101
                EM.stop
              }
            end
          
            Socky.stub!(:options).and_return({:port => 12345})
            Socky.logger = mock(:logger, :info => nil, :debug => nil)
            @runner.start
          end
        ensure
          Socky.logger = nil
        end
      end
    end
    
    it "#stop should call EM.stop" do
      begin
        Socky.logger = mock(:logger, :info => nil, :debug => nil)
        EM.should_receive(:stop)
        @runner.stop
      ensure
        Socky.logger = nil
      end
    end
    
  end
end