# frozen_string_literal: true

appraise 'rails-7.0' do
  gem 'activerecord', '~> 7'
  gem 'activesupport', '~> 7'
  gem 'railties', '~> 7'

  group :development do
    gem 'sqlite3', '~> 1.7.3'
    remove_gem 'tapioca'
  end
end

appraise 'rails-master' do
  gem 'activerecord', git: 'https://github.com/rails/rails.git'
  gem 'activesupport', git: 'https://github.com/rails/rails.git'
  gem 'railties', git: 'https://github.com/rails/rails.git'
  gem 'ostruct'

  group :development do
    gem 'sqlite3'
    gem 'pg', git: 'https://github.com/ged/ruby-pg.git'
  end
end
