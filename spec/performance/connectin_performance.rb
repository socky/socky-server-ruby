require 'spec_helper'
require 'performance_helper'
require 'benchmark'

describe 'Connecting Performance' do

  it "For x listeners" do
    [1, 10, 100].each do |count|
      results = []
      5.times do
        @application = Socky::Server::Application.new('test_application', 'test_secret')
        @channel = "presence"
        results << Benchmark.realtime {count.times { add_listener }}
        clean_application
      end
      print_result count, results
    end
  end

end






