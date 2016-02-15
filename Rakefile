#!/usr/bin/env rake
require 'bundler'
require 'bundler/gem_tasks'

Bundler.setup
Bundler.require

require 'rspec/core/rake_task'

task default: [:spec]

desc 'Run all RSpec tests'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.ruby_opts = ['-W0']
end
