require 'rspec/core/rake_task'

task :default => [:tc, :spec]

desc "Run the specs."
RSpec::Core::RakeTask.new

desc "Run the Sorbet type checker."
task :tc do
  system("bundle exec srb tc") || abort
end