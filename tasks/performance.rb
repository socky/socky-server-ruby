require 'rspec/core'
require 'rspec/core/rake_task'

namespace :spec do
  desc "Run the performance tests"
  RSpec::Core::RakeTask.new("performance") do |t|
    t.pattern = "./spec/**/*_performance.rb"
    t.rspec_opts = ["-c", "-f documentation"]
  end
end

