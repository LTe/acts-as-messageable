# frozen_string_literal: true

appraise 'rails-3.2' do
  gem 'activerecord', '~> 3.2.22'
  gem 'activesupport', '~> 3.2.22'
  gem 'railties', '~> 3.2.22'

  group :development do
    gem 'sqlite3', '~> 1.3.6'
  end
end

appraise 'rails-4.2' do
  gem 'activerecord', '~> 4.2'
  gem 'activesupport', '~> 4.2'
  gem 'railties', '~> 4.2'
  gem 'rdoc', '6.2.0'

  group :development do
    gem 'sqlite3', '~> 1.3.6'
  end
end

appraise 'rails-5.2' do
  gem 'activerecord', '~> 5.2.0'
  gem 'activesupport', '~> 5.2.0'
  gem 'railties', '~> 5.2.0'

  group :development do
    gem 'sqlite3', '~> 1.3.6'
  end
end

appraise 'rails-6.0' do
  gem 'activerecord', '~> 6'
  gem 'activesupport', '~> 6'
  gem 'railties', '~> 6'

  group :development do
    gem 'sqlite3', '~> 1.4.0'
  end
end

appraise 'rails-7.0' do
  gem 'activerecord', '~> 7'
  gem 'activesupport', '~> 7'
  gem 'railties', '~> 7'
end

appraise 'rails-master' do
  gem 'activerecord', git: 'https://github.com/rails/rails.git'
  gem 'activesupport', git: 'https://github.com/rails/rails.git'
  gem 'railties', git: 'https://github.com/rails/rails.git'

  group :development do
    gem 'sqlite3'
    gem 'pg', git: 'https://github.com/ged/ruby-pg.git'
  end
end
