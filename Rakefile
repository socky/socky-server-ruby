require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'tasks/performance'

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress"]
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec
