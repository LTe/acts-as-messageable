appraise "rails-3.2" do
  gem "activerecord", "~> 3.2.22"
  gem "activesupport", "~> 3.2.22"
  gem "railties", "~> 3.2.22"

  group :development do
    gem 'sqlite3', '~> 1.3.6'
  end
end

appraise "rails-4.2.11" do
  gem "activerecord", "~> 4.2.11"
  gem "activesupport", "~> 4.2.11"
  gem "railties", "~> 4.2.11"
  gem "rdoc", "6.2.0"

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

appraise 'rails-master' do
  git 'https://github.com/rails/rails.git', branch: :master do
    gem 'activerecord'
    gem 'activesupport'
    gem 'railties'
  end

  group :development do
    gem 'sqlite3'
  end
end
