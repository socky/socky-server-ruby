require 'spec_helper'
require 'performance_helper'
require 'benchmark'

describe 'Sending Many Messages Performance' do

  it "For 1 listener and x messages" do
    [1, 10, 100].each do |count|
      results = []
      5.times do
        @channel = "private"
        @application = application_with_listeners(1)
        results << Benchmark.realtime {send_messages(count)}
        clean_application
      end
      print_result count, results
    end
  end

end





