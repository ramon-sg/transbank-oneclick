require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new(:spec) do |s|
  s.libs << 'spec'
  s.pattern = 'spec/**/*_spec.rb'
end

task default: :spec



