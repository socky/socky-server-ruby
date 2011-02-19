# require 'spec_helper'
#
# describe Socky::Options::Parser do
#
#   context "class" do
#     context "#parse" do
#       before(:each) do
#         described_class.stub!(:puts)
#       end
#
#       it "should return empty hash on empty array" do
#         described_class.parse([]).should eql({})
#       end
#       it "should inform about inexistent option and exit" do
#         described_class.should_receive(:puts).with("invalid option: -z")
#         lambda { described_class.parse(["-z"]) }.should raise_error SystemExit
#       end
#       it "on -g or --generate should set config_path and generate default config file in specified destination" do
#         Socky::Options::Config.stub!(:generate)
#         ["-g","--generate"].each do |function|
#           Socky::Options::Config.should_receive(:generate).with("/tmp/socky.yml")
#           described_class.parse([function,"/tmp/socky.yml"]).should eql({:config_path => "/tmp/socky.yml"})
#         end
#       end
#       it "on -c or --config should set config_path to provided path" do
#         ["-c","--config"].each do |function|
#           described_class.parse([function,"/tmp/socky.yml"]).should eql({:config_path => "/tmp/socky.yml"})
#         end
#       end
#       it "on -p or --port should set port" do
#         ["-p","--port"].each do |function|
#           described_class.parse([function,"222"]).should eql({:port => 222})
#         end
#       end
#       it "on -s or --secure should set secure mode on" do
#         ["-s","--secure"].each do |function|
#           described_class.parse([function]).should eql({:secure => true})
#         end
#       end
#       it "on -P or --pid should set pid_path to provided path" do
#         ["-P","--pid"].each do |function|
#           described_class.parse([function,"/tmp/socky.pid"]).should eql({:pid_path => "/tmp/socky.pid"})
#         end
#       end
#       it "on -d or --daemon should set daemon mode on" do
#         ["-d","--daemon"].each do |function|
#           described_class.parse([function]).should eql({:daemonize => true})
#         end
#       end
#       it "on -l or --log should set log_path to provided path" do
#         ["-l","--log"].each do |function|
#           described_class.parse([function,"/tmp/socky.log"]).should eql({:log_path => "/tmp/socky.log"})
#         end
#       end
#       it "on --debug should set debug to true" do
#         described_class.parse(["--debug"]).should eql({:debug => true})
#       end
#       it "on --deep-debug should set debug and deep_debug to true" do
#         described_class.parse(["--deep-debug"]).should eql({:debug => true, :deep_debug => true})
#       end
#       it "on -? or --help should display usage" do
#         ["-?","--help"].each do |function|
#           described_class.should_receive(:puts).with(/Usage: socky \[options\]/)
#           lambda { described_class.parse([function]) }.should raise_error SystemExit
#         end
#       end
#       it "on -v or --version should dosplay current version" do
#         ["-v","--version"].each do |function|
#           described_class.should_receive(:puts).with("Socky #{Socky::VERSION}")
#           lambda { described_class.parse([function]) }.should raise_error SystemExit
#         end
#       end
#
#     end
#   end
# end