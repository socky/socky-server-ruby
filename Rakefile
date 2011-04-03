require 'rake'
require 'rake/clean'
CLEAN.include %w(**/*.{log,rbc})

require 'rspec/core/rake_task'

task :default => :spec

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress"]
  t.pattern = 'spec/**/*_spec.rb'
end
