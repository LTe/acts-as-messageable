require 'rake'
require 'rake/testtask'

desc 'Test the acts-as-messageable plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "acts-as-messageable"
    gemspec.email = "piotr.nielacny@gmail.com"
    gemspec.summary = "Make user messageable!;-)"
    gemspec.homepage = "http://github.com/LTe/acts_as_messageable"
    gemspec.authors = ["Piotr Nielacny"]
    gemspec.files = FileList["[A-Z]*", "{generators,lib,spec,rails}/**/*"] - FileList["**/*.log"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
