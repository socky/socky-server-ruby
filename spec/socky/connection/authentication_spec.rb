require 'spec_helper'

describe Socky::Connection::Authentication do
  include Socky::Connection::Authentication
  
  context "instance" do
    context "#subscribe_request" do
      before(:each) do
        stub!(:admin).and_return(false)
        stub!(:send_data)
      end
      it "should not call #send_subscribe_request if already authenticated" do
        stub!(:authenticated?).and_return(true)
        should_not_receive(:send_subscribe_request)
        subscribe_request
      end
      it "should call #send_subscribe_request if unauthenticated" do
        stub!(:authenticated?).and_return(false)
        should_receive(:send_subscribe_request)
        subscribe_request
      end
      it "should add self to connection list if #send_subscribe_request block is true" do
        EM.run do
          stub!(:authenticated?).and_return(false)
          stub!(:send_subscribe_request).and_yield(true)
          should_receive(:add_to_pool)
          subscribe_request
          EM.stop
        end
      end
      it "should be authenticated by url if #send_subscribe_request block is true" do
        EM.run do
          stub!(:authenticated?).and_return(false)
          stub!(:send_subscribe_request).and_yield(true)
          stub!(:add_to_pool)
          subscribe_request
          authenticated_by_url?.should be_true
          EM.stop
        end
      end
      it "should disconnect if #send_subscribe_request block is false" do
        EM.run do
          stub!(:send_subscribe_request).and_yield(false)
          should_receive(:disconnect)
          subscribe_request
          EM.add_timer(0.1) do
            EM.stop
          end
        end
      end
    end
    context "#unsubscribe_request" do
      it "should remove self from connection list if authenticated" do
        stub!(:admin).and_return(false)
        stub!(:authenticated?).and_return(true)
        should_receive(:remove_from_pool)
        unsubscribe_request
      end
      it "should send unsubscribe request if authenticated but not admin" do
        stub!(:admin).and_return(false)
        stub!(:authenticated?).and_return(true)
        stub!(:remove_from_pool)
        should_receive(:send_unsubscribe_request)
        unsubscribe_request
      end
      it "should not send unsubscribe request if authenticated and admin" do
        stub!(:admin).and_return(true)
        stub!(:authenticated?).and_return(true)
        stub!(:remove_from_pool)
        should_not_receive(:send_unsubscribe_request)
        unsubscribe_request
      end
      it "should not send unsubscribe request if unauthenticated" do
        stub!(:authenticated?).and_return(false)
        should_not_receive(:send_unsubscribe_request)
        unsubscribe_request
      end
    end
    context "#authenticated?" do
      it "should authenticate as admin if admin" do
        stub!(:admin).and_return(true)
        should_receive(:authenticate_as_admin)
        authenticated?
      end
      it "should authenticate as user if not admin" do
        stub!(:admin).and_return(false)
        should_receive(:authenticate_as_user)
        authenticated?
      end
    end
    context "#authenticate_as_admin" do
      it "should return true if client secret is equal server secret" do
        stub!(:secret).and_return("test")
        Socky.stub!(:options).and_return({:secret => "test"})
        authenticate_as_admin.should be_true
      end
      it "should return false if client secret is not equal server secret" do
        stub!(:secret).and_return("abstract")
        Socky.stub!(:options).and_return({:secret => "test"})
        authenticate_as_admin.should be_false
      end
      it "should return true if server secret is nil" do
        stub!(:secret).and_return("abstract")
        Socky.stub!(:options).and_return({:secret => nil})
        authenticate_as_admin.should be_true
      end
    end
    it "#authenticate_as_user should call #authenticated_by_url?" do
      should_receive(:authenticated_by_url?)
      authenticate_as_user
    end
    it "#authenticated_by_url? should return current status" do
      instance_variable_set('@authenticated_by_url',true)
      authenticated_by_url?.should be_true
      instance_variable_set('@authenticated_by_url',false)
      authenticated_by_url?.should be_false
    end
    context "#send_subscribe_request" do
      it "should build params for request if socky option subscribe_url is not nil" do
        Socky.stub!(:options).and_return({:subscribe_url => "any"})
        should_receive(:params_for_request)
        send_subscribe_request
      end
      it "should call Socky::NetRequest#post if socky option subscribe_url is not nil" do
        Socky.stub!(:options).and_return({:subscribe_url => "any"})
        stub!(:params_for_request)
        Socky::NetRequest.should_receive(:post)
        send_subscribe_request
      end
      it "should not call Socky::NetRequest#post if socky option subscribe_url is nil" do
        Socky.stub!(:options).and_return({:subscribe_url => nil})
        Socky::NetRequest.should_not_receive(:post)
        send_subscribe_request{}
      end
    end
    context "#send_unsubscribe_request" do
      it "should build params for request if socky option unsubscribe_url is not nil" do
        Socky.stub!(:options).and_return({:unsubscribe_url => "any"})
        should_receive(:params_for_request)
        send_unsubscribe_request{}
      end
      it "should call Socky::NetRequest#post if socky option unsubscribe_url is not nil" do
        Socky.stub!(:options).and_return({:unsubscribe_url => "any"})
        stub!(:params_for_request)
        Socky::NetRequest.should_receive(:post)
        send_unsubscribe_request{}
      end
      it "should not call Socky::NetRequest#post if socky option unsubscribe_url is nil" do
        Socky.stub!(:options).and_return({:unsubscribe_url => nil})
        Socky::NetRequest.should_not_receive(:post)
        send_unsubscribe_request{}
      end
    end
    context "#params_for_request" do
      before(:each) do
        stub!(:client)
        stub!(:secret)
        stub!(:channels).and_return([])
      end
      it "should return empty hash if none of (client,secret,channels) are set" do
        params_for_request.should eql({})
      end
      it "should return client as client_id if set" do
        stub!(:client).and_return("some client")
        params_for_request.should eql({:client_id => "some client"})
      end
      it "should return secret as client_secret if set" do
        stub!(:secret).and_return("some secret")
        params_for_request.should eql({:client_secret => "some secret"})
      end
      it "should return channels if not empty" do
        stub!(:channels).and_return(["some channel"])
        params_for_request.should eql({:channels => ["some channel"]})
      end
      it "should return client, secret and channels as hash if all are set" do
        stub!(:client).and_return("some client")
        stub!(:secret).and_return("some secret")
        stub!(:channels).and_return(["some channel"])
        params_for_request.should eql({:client_id => "some client", :client_secret => "some secret", :channels => ["some channel"]})
      end
    end
  end
end