# frozen_string_literal: true

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn 'Run `bundle install` to install missing gems'
  exit e.status_code
end
require 'rake'
require 'rubocop/rake_task'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  gem.name = 'acts-as-messageable'
  gem.email = 'piotr.nielacny@gmail.com'
  gem.summary = 'Make user messageable!;-)'
  gem.homepage = 'http://github.com/LTe/acts-as-messageable'
  gem.authors = ['Piotr Nielacny']
  gem.metadata = { 'rubygems_mfa_required' => true }
  # dependencies defined in Gemfile
end

Jeweler::RubygemsDotOrgTasks.new
RuboCop::RakeTask.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['-fd -c --order random']
  spec.pattern = FileList['spec/**/*_spec.rb']
end

path = File.expand_path(__dir__)
Dir.glob("#{path}/tasks/**/*.rake").each { |f| import f }

task default: :spec
