require 'spec_helper'

describe Socky::NetRequest do
  
  context "class" do
    context "#post" do
      it "should send EventMachine::HttpRequest to url" do
        EventMachine::HttpRequest.should_receive(:new).with("some url")
        described_class.post("some url")
      end
      it "should send EventMachine::HttpRequest post request with specified params" do
        request = mock(:request)
        EventMachine::HttpRequest.stub!(:new).and_return(request)
        request.should_receive(:post).with({:body => {:test => true}, :timeout => 3})
        described_class.post("some url", :test => true)
      end
      it "should rescue from EM::HttpRequest and return false" do
        EM.run do
          described_class.post("inexistent").should be_false
          EM.stop
        end
      end
      it "should call block with false if request return status other than 200" do
        EM.run do
          described_class.post("http://127.0.0.1:8765/fail") do |response|
            response.should be_false
            EM.stop
          end.should be_true
        end
      end
      it "should call block with true if request return status 200" do
        EM.run do
          described_class.post("http://127.0.0.1:8765/") do |response|
            response.should be_true
            EM.stop
          end.should be_true
        end
      end
    end
  end
  
end