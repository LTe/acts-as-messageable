# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

CURRENT_RAILS_VERSION = '7.1'
rails_version = ENV.fetch('RAILS_VERSION', CURRENT_RAILS_VERSION)

group :development do # rubocop:disable Metrics/BlockLength
  if rails_version == 'main'
    gem 'rails', github: 'rails/rails', branch: 'main'
  else
    rails_version = CURRENT_RAILS_VERSION if rails_version == 'current'
    gem 'rails', "~> #{rails_version}.0"
  end
  if rails_version == '7.0'
    gem 'sqlite3', '~> 1.4'
  else
    gem 'sqlite3' # rubocop:disable Gemspec/DevelopmentDependencies
  end

  gem 'concurrent-ruby', '1.3.4'
  gem 'faraday', '~> 1.8', require: false
  gem 'kramdown', '~> 2.4', require: false
  gem 'mutex_m', '~> 0.1', require: false
  gem 'ostruct', '~> 0.5', require: false
  gem 'pg', '~> 1.5', require: false
  gem 'pry', '~> 0.14', require: false
  gem 'rake', '~> 13.0', require: false
  gem 'rspec', '~> 3.12', require: false
  gem 'rubocop', '~> 1.72', require: false
  gem 'rubocop-sorbet', '~> 0.8', require: false
  gem 'tapioca', github: 'Shopify/tapioca', require: false
  gem 'timecop', '~> 0.9', require: false
  gem 'unparser', '~> 0.6', require: false
  gem 'yard', '~> 0.9', require: false
end
