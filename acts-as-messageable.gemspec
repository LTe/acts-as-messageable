# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# frozen_string_literal: true

# stub: acts-as-messageable 0.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = 'acts-as-messageable'
  s.version = '0.5.0'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.metadata = { 'rubygems_mfa_required' => 'true' } if s.respond_to? :metadata=
  s.require_paths = ['lib']
  s.authors = ['Piotr Nielacny']
  s.email = 'piotr.nielacny@gmail.com'
  s.extra_rdoc_files = [
    'README.md'
  ]
  s.files = [
    '.coveralls.yml',
    '.dockerignore',
    '.github/dependabot.yml',
    '.github/workflows/test.yml',
    '.rspec',
    '.rubocop.yml',
    '.rubocop_todo.yml',
    'Appraisals',
    'Dockerfile',
    'Gemfile',
    'Gemfile.lock',
    'MIT-LICENSE',
    'README.md',
    'Rakefile',
    'VERSION',
    'acts-as-messageable.gemspec',
    'docker-compose.yml',
    'gemfiles/rails_3.2.gemfile',
    'gemfiles/rails_4.2.gemfile',
    'gemfiles/rails_5.2.gemfile',
    'gemfiles/rails_6.0.gemfile',
    'gemfiles/rails_7.0.gemfile',
    'gemfiles/rails_master.gemfile',
    'lib/acts-as-messageable.rb',
    'lib/acts_as_messageable.rb',
    'lib/acts_as_messageable/message.rb',
    'lib/acts_as_messageable/model.rb',
    'lib/acts_as_messageable/rails3.rb',
    'lib/acts_as_messageable/rails4.rb',
    'lib/acts_as_messageable/rails6.rb',
    'lib/acts_as_messageable/railtie.rb',
    'lib/acts_as_messageable/relation.rb',
    'lib/acts_as_messageable/scopes.rb',
    'lib/generators/acts_as_messageable/migration/migration_generator.rb',
    'lib/generators/acts_as_messageable/migration/templates/migration.rb',
    'lib/generators/acts_as_messageable/migration/templates/migration_indexes.rb',
    'lib/generators/acts_as_messageable/migration/templates/migration_opened_as_datetime.rb',
    'lib/generators/acts_as_messageable/migration/templates/migration_permanent.rb',
    'spec/acts_as_messageable_spec.rb',
    'spec/custom_class_spec.rb',
    'spec/custom_required_spec.rb',
    'spec/group_messages_spec.rb',
    'spec/migrations_spec.rb',
    'spec/spec_helper.rb',
    'spec/support/admin.rb',
    'spec/support/custom_message.rb',
    'spec/support/custom_message_uuid.rb',
    'spec/support/custom_search_user.rb',
    'spec/support/men.rb',
    'spec/support/send_message.rb',
    'spec/support/table_schema.rb',
    'spec/support/user.rb',
    'spec/support/uuid_user.rb'
  ]
  s.homepage = 'http://github.com/LTe/acts-as-messageable'
  s.summary = 'Make user messageable!;-)'

  if s.respond_to? :specification_version

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0')
      s.add_runtime_dependency('activerecord', ['>= 0'])
      s.add_runtime_dependency('activesupport', ['>= 0'])
      s.add_runtime_dependency('ancestry', ['>= 0'])
      s.add_runtime_dependency('railties', ['>= 0'])
      s.add_development_dependency('appraisal', ['>= 0'])
      s.add_development_dependency('coveralls_reborn', ['>= 0'])
      s.add_development_dependency('jeweler', ['>= 0'])
      s.add_development_dependency('pg', ['>= 0'])
      s.add_development_dependency('pry', ['>= 0'])
      s.add_development_dependency('rspec', ['>= 0'])
      s.add_development_dependency('rubocop', ['>= 0'])
      s.add_development_dependency('sqlite3', ['>= 0'])
      s.add_development_dependency('timecop', ['>= 0'])
      s.add_development_dependency('yard', ['>= 0'])
    else
      s.add_dependency('activerecord', ['>= 0'])
      s.add_dependency('activesupport', ['>= 0'])
      s.add_dependency('ancestry', ['>= 0'])
      s.add_dependency('appraisal', ['>= 0'])
      s.add_dependency('appraisal', ['>= 0'])
      s.add_dependency('coveralls_reborn', ['>= 0'])
      s.add_dependency('coveralls_reborn', ['>= 0'])
      s.add_dependency('jeweler', ['>= 0'])
      s.add_dependency('jeweler', ['>= 0'])
      s.add_dependency('pg', ['>= 0'])
      s.add_dependency('pg', ['>= 0'])
      s.add_dependency('pry', ['>= 0'])
      s.add_dependency('pry', ['>= 0'])
      s.add_dependency('railties', ['>= 0'])
      s.add_dependency('rspec', ['>= 0'])
      s.add_dependency('rubocop', ['>= 0'])
      s.add_dependency('sqlite3', ['>= 0'])
      s.add_dependency('timecop', ['>= 0'])
      s.add_dependency('yard', ['>= 0'])
    end
  else
    s.add_dependency('activerecord', ['>= 0'])
    s.add_dependency('activesupport', ['>= 0'])
    s.add_dependency('ancestry', ['>= 0'])
    s.add_dependency('railties', ['>= 0'])
    s.add_dependency('rspec', ['>= 0'])
    s.add_dependency('rubocop', ['>= 0'])
    s.add_dependency('sqlite3', ['>= 0'])
    s.add_dependency('timecop', ['>= 0'])
    s.add_dependency('yard', ['>= 0'])
  end
end
