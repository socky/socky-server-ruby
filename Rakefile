require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'
require 'rake/clean'
CLEAN.include %w(**/*.{log,rbc})

require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new(:spec) do |t|
end
