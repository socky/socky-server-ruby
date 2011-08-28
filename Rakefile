require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require File.expand_path(File.join(File.dirname(__FILE__), 'tasks/performance'))

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress"]
  t.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec
