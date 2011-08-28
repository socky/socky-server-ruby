require 'spec_helper'
require 'performance_helper'
require 'benchmark'

describe 'Sending Message To Many Listeners Performance' do

  it "For x listeners and 1 message" do
    [1, 10, 100].each do |count|
      results = []
      5.times do 
        @application = application_with_listeners(count)
        results << Benchmark.realtime {send_messages(1)}
        clean_application
      end
      print_result count, results
    end
  end
end






