# typed: ignore
# frozen_string_literal: true

require 'spec_helper'

def create_dummy_app
  system(<<-COMMAND)
    bundle exec rails new dummy --skip-test-unit --skip-spring --skip-webpack-install --skip-bootsnap \
    --skip-active-storage --skip-active-job --skip-action-cable --skip-javascript --skip-action-mailer \
    --skip-bundle -d sqlite3
  COMMAND
  run_in_app("sed -i '/^ruby /d' Gemfile")
end

def add_gem_to_gemfile
  run_in_app("echo gem \"'acts-as-messageable', path: '../'\" >> Gemfile")
  run_in_app("echo gem \"'concurrent-ruby', '< 1.3.4'\" >> Gemfile")
  run_in_app("echo gem \"'bigdecimal'\" >> Gemfile")
  run_in_app("echo gem \"'mutex_m'\" >> Gemfile")
  run_in_app("echo gem \"'benchmark'\" >> Gemfile")
  run_in_app("echo gem \"'ostruct'\" >> Gemfile")
end

def run_bundler
  run_in_app('bundle update')
end

def run_generators(option = '')
  run_in_app("bundle exec rails g acts_as_messageable:migration #{option}")
end

def run_migrations
  run_in_app('bundle exec rake db:migrate')
end

def rollback_migrations
  run_in_app('bundle exec rake db:migrate VERSION=0')
end

def run_in_app(command)
  Bundler.clean_system("cd dummy; BUNDLE_GEMFILE=./Gemfile #{command}")
end

def remove_dummy_app
  system 'rm -rf dummy'
end

def skip_generators?
  ENV.fetch('RUN_GENERATORS', 'false') == 'false'
end

describe 'migration' do
  before do
    create_dummy_app
    add_gem_to_gemfile
    run_bundler
  end

  after do
    remove_dummy_app
  end

  it 'runs migrations and revert them', skip: skip_generators? do
    run_generators

    expect(run_migrations).to be_truthy
    expect(rollback_migrations).to be_truthy
  end

  it 'runs migrations and revert them with uuid option', skip: skip_generators? do
    run_generators('--uuid')

    expect(run_migrations).to be_truthy
    expect(rollback_migrations).to be_truthy
  end

  it 'runs migrations and revert them with uuid option and custom table', skip: skip_generators? do
    run_generators('my_messages --uuid')

    expect(run_migrations).to be_truthy
    expect(rollback_migrations).to be_truthy
  end
end
