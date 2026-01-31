# typed: strict
require "byebug"
require "simplecov"
require "simplecov-cobertura"

SimpleCov.start
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end
