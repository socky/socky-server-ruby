require 'spec_helper'

FILES_DIR = File.join(File.dirname(__FILE__), '..', '..', 'files')

describe Socky::Options::Config do

  context "class" do
    before(:each) do
      described_class.stub!(:puts)
    end

    context "#read" do
      it "should return empty hash if config path is nil" do
        described_class.read(nil).should eql({})
      end
      it "should raise error if file doesn't exists" do
        described_class.should_receive(:puts).with("You must generate a config file (socky -g filename.yml)")
        lambda { described_class.read("abstract") }.should raise_error SystemExit
      end
      it "should raise error if file is corrupted" do
        described_class.should_receive(:puts).with("Provided config file is invalid.")
        lambda { described_class.read(FILES_DIR + "/invalid.yml") }.should raise_error SystemExit
      end
      it "should not raise error if :kill option is provided" do
        described_class.should_not_receive(:puts).with("Provided config file is invalid.")
        lambda { described_class.read(FILES_DIR + "/invalid.yml", :kill => true) }.should_not raise_error SystemExit
      end
      it "should return valid options if file is valid" do
        lambda { described_class.read(FILES_DIR + "/default.yml") }.should_not raise_error SystemExit
        described_class.read(FILES_DIR + "/default.yml").should eql(default_options)
      end
    end

    context "#generate" do
      it "should raise error if file exists" do
        described_class.should_receive(:puts).with("Config file already exists. You must remove it before generating a new one.")
        lambda { described_class.generate(FILES_DIR + "/invalid.yml") }.should raise_error SystemExit
      end
      it "should raise error if path is not valid" do
        described_class.should_receive(:puts).with("Config file is unavailable - please choose another.")
        lambda { described_class.generate("/proc/inexistent") }.should raise_error SystemExit
      end
      it "should create file and exit if path is valid" do
        path = FILES_DIR + "/inexistent.yml"
        begin
          described_class.should_receive(:puts).with("Config file generated at #{path}")
          lambda { described_class.generate(path) }.should raise_error SystemExit
        ensure
          FileUtils.rm(path, :force => true)
        end
      end
      it "should generate file that after parsing will equal default config" do
        path = FILES_DIR + "/inexistent.yml"
        begin
          described_class.should_receive(:puts).with("Config file generated at #{path}")
          lambda { described_class.generate(path) }.should raise_error SystemExit
          lambda { described_class.read(path) }.should_not raise_error SystemExit
          described_class.read(path).should eql(default_options)
        ensure
          FileUtils.rm(path, :force => true)
        end
      end
    end
  end

  def default_options
    {
      :port => 8080,
      :debug => false,
      :secret => "my_secret_key",
      :secure => false
    }
  end

end