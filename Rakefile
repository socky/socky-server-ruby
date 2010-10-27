require 'rake'
require 'rake/clean'
CLEAN.include %w(**/*.{log,rbc})

require 'spec/rake/spectask'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.ruby_opts = ['-rtest/unit']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "socky-server"
    gemspec.summary = "Socky is a WebSocket server and client for Ruby"
    gemspec.description = "Socky is a WebSocket server and client for Ruby"
    gemspec.email = "bernard.potocki@imanel.org"
    gemspec.homepage = "http://imanel.org/projects/socky"
    gemspec.authors = ["Bernard Potocki"]
    gemspec.add_dependency 'em-websocket', '>= 0.1.4'
    gemspec.add_dependency 'em-http-request'
    gemspec.add_dependency 'json'
    gemspec.add_development_dependency 'rspec', '~> 1.3'
    gemspec.add_development_dependency 'rack'
    gemspec.add_development_dependency 'mongrel'
    gemspec.files.exclude ".gitignore"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
