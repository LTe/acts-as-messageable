# frozen_string_literal: true

source 'http://rubygems.org'

gemspec

CURRENT_RAILS_VERSION = '7.1'
rails_version = ENV.fetch('RAILS_VERSION', CURRENT_RAILS_VERSION)

gem 'ancestry', require: false
gem 'sorbet-rails', require: false
gem 'sorbet-static-and-runtime', require: false

group :development do
  if rails_version == 'main'
    gem 'rails', github: 'rails/rails', branch: 'main'
  else
    rails_version = CURRENT_RAILS_VERSION if rails_version == 'current'
    gem 'rails', "~> #{rails_version}.0"
  end
  if rails_version == '7.0'
    gem 'sqlite3', '~> 1.4'
  else
    gem 'sqlite3'
  end

  gem 'appraisal', require: false
  gem 'concurrent-ruby', '< 1.3.4'
  gem 'coveralls_reborn', require: false
  gem 'jeweler', require: false
  gem 'kramdown', require: false
  gem 'mize', require: false
  gem 'mutex_m', require: false
  gem 'ostruct', require: false
  gem 'pg', require: false
  gem 'pry', require: false
  gem 'rake', require: false
  gem 'rspec', require: false
  gem 'rubocop', require: false
  gem 'rubocop-sorbet', require: false
  gem 'sord', require: false
  gem 'tapioca', github: 'Shopify/tapioca', require: false
  gem 'timecop', require: false
  gem 'unparser', require: false
  gem 'yard', require: false
end
