require 'spec_helper'

describe Socky::Misc do
  include Socky::Misc
  
  shared_examples_for "socky_misc" do
    it "#option should return Socky.options" do
      Socky.stub!(:options).and_return({:test => true})
      @object.options.should eql({:test => true})
    end
    it "#options= should set Socky.options" do
      default_options = Socky.options
      begin
        Socky.options = {}
        @object.options = {:test => true}
        Socky.options.should eql({:test => true})
      ensure
        Socky.options = default_options
      end
    end
    it "#name should return self formatted name" do
      @object.name.should eql("#{@object.class.to_s.split("::").last}(#{@object.object_id})")
    end
    it "#log_path should return Socky.log_path" do
      Socky.stub!(:log_path).and_return("abstract")
      @object.log_path.should eql("abstract")
    end
    it "#config_path should return Socky.config_path" do
      Socky.stub!(:config_path).and_return("abstract")
      @object.config_path.should eql("abstract")
    end
    it "#info should send joined args to Socky.logger.info" do
      Socky.logger.stub!(:info)
      Socky.logger.should_receive(:info).with("first second third")
      @object.info(["first","second","third"])
    end
    it "#debug should send joined args to Socky.logger.debug" do
      Socky.logger.stub!(:debug)
      Socky.logger.should_receive(:debug).with("first second third")
      @object.debug(["first","second","third"])
    end
    it "#error should send self name and error message to self.debug" do
      @object.stub!(:debug)
      error = mock(:abstract_error, :class => "AbstractError", :message => "abstract")
      @object.should_receive(:debug).with([@object.name,"raised:","AbstractError","abstract"])
      @object.error(@object.name, error)
    end
    context "#symbolize_keys" do
      it "return args if args are not hash" do
        @object.symbolize_keys("abstract").should eql("abstract")
      end
      it "return hash with symbolized keys if args is hash" do
        hash = {"aaa" => "a", 123 => "b"}
        @object.symbolize_keys(hash).should eql({:aaa => "a", 123 => "b"})
      end
    end
  end

  context "class" do
    before(:each) do
      @object = self.class
    end
    it_should_behave_like "socky_misc"
  end

  context "instance" do
    before(:each) do
      @object = self
    end
    it_should_behave_like "socky_misc"
  end
  
end
      