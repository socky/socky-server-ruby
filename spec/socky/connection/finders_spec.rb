require 'spec_helper'

describe Socky::Connection::Finders do
  include Socky::Connection::Finders
  include Socky::Misc

  context "class" do
    before(:each) do
      @connection1 = mock(:connection1, :channels => [nil], :user => "user1")
      @connection2 = mock(:connection2, :channels => ["1", "3", "5"], :user => "user1")
      @connection3 = mock(:connection3, :channels => ["2", "5"], :user => "user2")
      @connection4 = mock(:connection4, :channels => ["3", "5"], :user => "user3")
      @connections = [@connection1,@connection2,@connection3,@connection4]
      @connections.collect { |connection| Socky::Connection.connections << connection }
    end
    after(:each) do
      Socky::Connection.connections.clear
    end

    it "#find_all should return all connections" do
      find_all.should eql(@connections)
    end
    context "#find" do
      it "should return all connections if no options specified" do
        find.should eql(@connections)
      end
      context "if :channels option is specified" do
        it "should return all connections if :channels is nil" do
          find(:channels => nil).should eql(@connections)
        end
        it "should return none connections if :channels is empty" do
          find(:channels => []).should eql([])
        end
        it "should return all connections that include specified channel" do
          find(:channels => "3").should eql([@connection2,@connection4])
        end
        it "should return all connections that include at last one of specified channels" do
          find(:channels => ["2","3"]).should eql([@connection2,@connection3,@connection4])
        end
      end
      context "if :users option is specified" do
        it "should return all connections if :users is nil" do
          find(:users => nil).should eql(@connections)
        end
        it "should return none connections if :users is empty" do
          find(:users => []).should eql([])
        end
        it "should return only connections from specified user" do
          find(:users => "user1").should eql([@connection1,@connection2])
        end
        it "should return only connections from specified users if array provided" do
          find(:users => ["user1","user2"]).should eql([@connection1,@connection2,@connection3])
        end
      end
      context "if both :channels and :users options are provided" do
        context "but :channels are nil" do
          it "should return only connections from specified user" do
            find(:channels => nil,:users => "user1").should eql([@connection1,@connection2])
          end
          it "should return only connections from specified users if array provided" do
            find(:channels => nil,:users => ["user1","user2"]).should eql([@connection1,@connection2,@connection3])
          end
        end
        context "but :channels are empty" do
          it "should return none connections" do
            find(:channels => [],:users => "user1").should eql([])
          end
          it "should return none connections if array provided" do
            find(:channels => [],:users => ["user1","user2"]).should eql([])
          end
        end
        context "but :users are nil" do
          it "should return all connections that include specified channel" do
            find(:users => nil,:channels => "3").should eql([@connection2,@connection4])
          end
          it "should return all connections that include at last one of specified channels" do
            find(:users => nil,:channels => ["2","3"]).should eql([@connection2,@connection3,@connection4])
          end
        end
        context "but :users are empty" do
          it "should return none connections" do
            find(:users => [],:channels => "3").should eql([])
          end
          it "should return none connections if array provided" do
            find(:users => [],:channels => ["2","3"]).should eql([])
          end
        end
        it "should return only connections from specified user that include specified channel" do
          find(:users => "user1",:channels => "3").should eql([@connection2])
          find(:users => "user1",:channels => "2").should eql([])
        end
        it "should return only connections from specified user that include one of specified channels" do
          find(:users => "user1",:channels => ["2","3"]).should eql([@connection2])
        end
        it "should return only connections from specified users that include specified channel" do
          find(:users => ["user1","user2"],:channels => "2").should eql([@connection3])
        end
        it "should return only connections from specified users that include at last one of specified channels" do
          find(:users => ["user1","user2"],:channels => ["2","1"]).should eql([@connection2,@connection3])
        end
      end
    end

  end
end