require 'spec_helper'

describe Socky::Options do
  
  context "class" do
    before(:all) do
      @default_options = Socky.options
    end
    after(:each) do
      Socky.options = @default_options
    end

    context "#prepare" do
      before(:each) do
        Socky::Options::Parser.stub!(:parse).and_return({})
        Socky::Options::Config.stub!(:read).and_return({})
      end
      it "should call parser with self option" do
        Socky::Options::Parser.should_receive(:parse).with([:a,:b,:c])
        Socky::Options.prepare([:a,:b,:c])
      end
      it "should call read_config with patch" do
        Socky::Options::Config.should_receive(:read).with("/var/run/socky.yml", :kill => nil)
        Socky::Options.prepare([])
      end
      it "should set Socky options to default hash when parse_options and read_config don't do anything" do
        Socky::Options.prepare([])
        Socky.options.should eql(default_options)
      end
      it "should value parse_options over default values" do
        Socky::Options::Parser.stub!(:parse).and_return(:log_path => "parsed")
        Socky::Options.prepare([])
        Socky.options.should eql(default_options.merge(:log_path=>"parsed"))
      end
      it "should value read_config over default values" do
        Socky::Options::Config.stub!(:read).and_return(:log_path => "from config")
        Socky::Options.prepare([])
        Socky.options.should eql(default_options.merge(:log_path=>"from config"))
      end
      it "should value parse_options over read_config" do
        Socky::Options::Config.stub!(:read).and_return(:log_path => "from config")
        Socky::Options::Parser.stub!(:parse).and_return(:log_path => "parsed")
        Socky::Options.prepare([])
        Socky.options.should eql(default_options.merge(:log_path=>"parsed"))
      end
    end
  end
  
  def default_options
    {
      :port => 8080,
      :log_path => nil,
      :debug => false,
      :deep_debug => false,
      :secure => false,
      :config_path => "/var/run/socky.yml"
    }
  end

end