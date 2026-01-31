# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rubocop/rake_task'

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
