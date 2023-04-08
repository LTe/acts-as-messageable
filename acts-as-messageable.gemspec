# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: acts-as-messageable 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "acts-as-messageable".freeze
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Piotr Nielacny".freeze]
  s.date = "2023-04-08"
  s.email = "piotr.nielacny@gmail.com".freeze
  s.executables = ["tapioca".freeze]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    ".coveralls.yml",
    ".dockerignore",
    ".github/dependabot.yml",
    ".github/workflows/test.yml",
    ".rspec",
    ".rubocop.yml",
    ".rubocop_todo.yml",
    ".ruby-version",
    "Appraisals",
    "Dockerfile",
    "Gemfile",
    "Gemfile.lock",
    "MIT-LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "acts-as-messageable.gemspec",
    "bin/tapioca",
    "docker-compose.yml",
    "gemfiles/rails_3.2.gemfile",
    "gemfiles/rails_4.2.gemfile",
    "gemfiles/rails_5.2.gemfile",
    "gemfiles/rails_6.0.gemfile",
    "gemfiles/rails_7.0.gemfile",
    "gemfiles/rails_master.gemfile",
    "lib/acts-as-messageable.rb",
    "lib/acts_as_messageable.rb",
    "lib/acts_as_messageable/message.rb",
    "lib/acts_as_messageable/model.rb",
    "lib/acts_as_messageable/rails3.rb",
    "lib/acts_as_messageable/rails4.rb",
    "lib/acts_as_messageable/rails6.rb",
    "lib/acts_as_messageable/railtie.rb",
    "lib/acts_as_messageable/relation.rb",
    "lib/acts_as_messageable/scopes.rb",
    "lib/generators/acts_as_messageable/migration/migration_generator.rb",
    "lib/generators/acts_as_messageable/migration/templates/migration.rb",
    "lib/generators/acts_as_messageable/migration/templates/migration_indexes.rb",
    "lib/generators/acts_as_messageable/migration/templates/migration_opened_as_datetime.rb",
    "lib/generators/acts_as_messageable/migration/templates/migration_permanent.rb",
    "sorbet/config",
    "sorbet/rbi/annotations/actionpack.rbi",
    "sorbet/rbi/annotations/actionview.rbi",
    "sorbet/rbi/annotations/activerecord.rbi",
    "sorbet/rbi/annotations/activesupport.rbi",
    "sorbet/rbi/annotations/faraday.rbi",
    "sorbet/rbi/annotations/railties.rbi",
    "sorbet/rbi/annotations/rainbow.rbi",
    "sorbet/rbi/dsl/abstract_controller/caching.rbi",
    "sorbet/rbi/dsl/abstract_controller/caching/fragments.rbi",
    "sorbet/rbi/dsl/abstract_controller/callbacks.rbi",
    "sorbet/rbi/dsl/abstract_controller/helpers.rbi",
    "sorbet/rbi/dsl/abstract_controller/rendering.rbi",
    "sorbet/rbi/dsl/abstract_controller/url_for.rbi",
    "sorbet/rbi/dsl/action_controller/caching.rbi",
    "sorbet/rbi/dsl/action_controller/conditional_get.rbi",
    "sorbet/rbi/dsl/action_controller/content_security_policy.rbi",
    "sorbet/rbi/dsl/action_controller/data_streaming.rbi",
    "sorbet/rbi/dsl/action_controller/etag_with_flash.rbi",
    "sorbet/rbi/dsl/action_controller/etag_with_template_digest.rbi",
    "sorbet/rbi/dsl/action_controller/flash.rbi",
    "sorbet/rbi/dsl/action_controller/form_builder.rbi",
    "sorbet/rbi/dsl/action_controller/helpers.rbi",
    "sorbet/rbi/dsl/action_controller/params_wrapper.rbi",
    "sorbet/rbi/dsl/action_controller/redirecting.rbi",
    "sorbet/rbi/dsl/action_controller/renderers.rbi",
    "sorbet/rbi/dsl/action_controller/renderers/all.rbi",
    "sorbet/rbi/dsl/action_controller/request_forgery_protection.rbi",
    "sorbet/rbi/dsl/action_controller/rescue.rbi",
    "sorbet/rbi/dsl/action_controller/test_case/behavior.rbi",
    "sorbet/rbi/dsl/action_controller/url_for.rbi",
    "sorbet/rbi/dsl/action_dispatch/routing/url_for.rbi",
    "sorbet/rbi/dsl/action_view/helpers.rbi",
    "sorbet/rbi/dsl/action_view/helpers/form_helper.rbi",
    "sorbet/rbi/dsl/action_view/helpers/form_tag_helper.rbi",
    "sorbet/rbi/dsl/action_view/helpers/text_helper.rbi",
    "sorbet/rbi/dsl/action_view/layouts.rbi",
    "sorbet/rbi/dsl/action_view/rendering.rbi",
    "sorbet/rbi/dsl/active_model/attribute_methods.rbi",
    "sorbet/rbi/dsl/active_model/attributes.rbi",
    "sorbet/rbi/dsl/active_model/dirty.rbi",
    "sorbet/rbi/dsl/active_model/serializers/json.rbi",
    "sorbet/rbi/dsl/active_model/validations.rbi",
    "sorbet/rbi/dsl/active_model/validations/callbacks.rbi",
    "sorbet/rbi/dsl/active_record/attribute_methods.rbi",
    "sorbet/rbi/dsl/active_record/attribute_methods/dirty.rbi",
    "sorbet/rbi/dsl/active_record/attribute_methods/time_zone_conversion.rbi",
    "sorbet/rbi/dsl/active_record/attributes.rbi",
    "sorbet/rbi/dsl/active_record/callbacks.rbi",
    "sorbet/rbi/dsl/active_record/core.rbi",
    "sorbet/rbi/dsl/active_record/encryption/encryptable_record.rbi",
    "sorbet/rbi/dsl/active_record/inheritance.rbi",
    "sorbet/rbi/dsl/active_record/integration.rbi",
    "sorbet/rbi/dsl/active_record/locking/optimistic.rbi",
    "sorbet/rbi/dsl/active_record/model_schema.rbi",
    "sorbet/rbi/dsl/active_record/nested_attributes.rbi",
    "sorbet/rbi/dsl/active_record/readonly_attributes.rbi",
    "sorbet/rbi/dsl/active_record/reflection.rbi",
    "sorbet/rbi/dsl/active_record/scoping.rbi",
    "sorbet/rbi/dsl/active_record/scoping/default.rbi",
    "sorbet/rbi/dsl/active_record/serialization.rbi",
    "sorbet/rbi/dsl/active_record/signed_id.rbi",
    "sorbet/rbi/dsl/active_record/test_fixtures.rbi",
    "sorbet/rbi/dsl/active_record/timestamp.rbi",
    "sorbet/rbi/dsl/active_record/validations.rbi",
    "sorbet/rbi/dsl/active_support/actionable_error.rbi",
    "sorbet/rbi/dsl/active_support/callbacks.rbi",
    "sorbet/rbi/dsl/active_support/rescuable.rbi",
    "sorbet/rbi/dsl/active_support/testing/file_fixtures.rbi",
    "sorbet/rbi/gems/actionpack@7.0.4.3.rbi",
    "sorbet/rbi/gems/actionview@7.0.4.3.rbi",
    "sorbet/rbi/gems/activemodel@7.0.4.3.rbi",
    "sorbet/rbi/gems/activerecord@7.0.4.3.rbi",
    "sorbet/rbi/gems/activesupport@7.0.4.3.rbi",
    "sorbet/rbi/gems/addressable@2.4.0.rbi",
    "sorbet/rbi/gems/ancestry@4.3.2.rbi",
    "sorbet/rbi/gems/appraisal@2.4.1.rbi",
    "sorbet/rbi/gems/ast@2.4.2.rbi",
    "sorbet/rbi/gems/builder@3.2.4.rbi",
    "sorbet/rbi/gems/coderay@1.1.3.rbi",
    "sorbet/rbi/gems/commander@4.6.0.rbi",
    "sorbet/rbi/gems/concurrent-ruby@1.2.2.rbi",
    "sorbet/rbi/gems/coveralls_reborn@0.27.0.rbi",
    "sorbet/rbi/gems/crass@1.0.6.rbi",
    "sorbet/rbi/gems/descendants_tracker@0.0.4.rbi",
    "sorbet/rbi/gems/diff-lcs@1.5.0.rbi",
    "sorbet/rbi/gems/docile@1.4.0.rbi",
    "sorbet/rbi/gems/erubi@1.12.0.rbi",
    "sorbet/rbi/gems/faraday@0.9.2.rbi",
    "sorbet/rbi/gems/git@1.11.0.rbi",
    "sorbet/rbi/gems/github_api@0.16.0.rbi",
    "sorbet/rbi/gems/hashie@5.0.0.rbi",
    "sorbet/rbi/gems/highline@2.0.3.rbi",
    "sorbet/rbi/gems/i18n@1.12.0.rbi",
    "sorbet/rbi/gems/jeweler@2.3.9.rbi",
    "sorbet/rbi/gems/json@2.6.3.rbi",
    "sorbet/rbi/gems/jwt@2.5.0.rbi",
    "sorbet/rbi/gems/loofah@2.19.1.rbi",
    "sorbet/rbi/gems/method_source@1.0.0.rbi",
    "sorbet/rbi/gems/mime-types@2.99.3.rbi",
    "sorbet/rbi/gems/minitest@5.18.0.rbi",
    "sorbet/rbi/gems/multi_json@1.15.0.rbi",
    "sorbet/rbi/gems/multi_xml@0.6.0.rbi",
    "sorbet/rbi/gems/multipart-post@2.2.3.rbi",
    "sorbet/rbi/gems/netrc@0.11.0.rbi",
    "sorbet/rbi/gems/nokogiri@1.14.2.rbi",
    "sorbet/rbi/gems/oauth2@1.4.8.rbi",
    "sorbet/rbi/gems/parallel@1.22.1.rbi",
    "sorbet/rbi/gems/parser@3.2.2.0.rbi",
    "sorbet/rbi/gems/pg@1.4.6.rbi",
    "sorbet/rbi/gems/polyfill@1.9.0.rbi",
    "sorbet/rbi/gems/pry@0.14.2.rbi",
    "sorbet/rbi/gems/psych@4.0.6.rbi",
    "sorbet/rbi/gems/racc@1.6.2.rbi",
    "sorbet/rbi/gems/rack-test@2.0.2.rbi",
    "sorbet/rbi/gems/rack@2.2.6.4.rbi",
    "sorbet/rbi/gems/rails-dom-testing@2.0.3.rbi",
    "sorbet/rbi/gems/rails-html-sanitizer@1.5.0.rbi",
    "sorbet/rbi/gems/railties@7.0.4.3.rbi",
    "sorbet/rbi/gems/rainbow@3.1.1.rbi",
    "sorbet/rbi/gems/rake@13.0.6.rbi",
    "sorbet/rbi/gems/rbi@0.0.16.rbi",
    "sorbet/rbi/gems/rbs@2.8.0.rbi",
    "sorbet/rbi/gems/rchardet@1.8.0.rbi",
    "sorbet/rbi/gems/rdoc@6.5.0.rbi",
    "sorbet/rbi/gems/regexp_parser@2.7.0.rbi",
    "sorbet/rbi/gems/rexml@3.2.5.rbi",
    "sorbet/rbi/gems/rspec-core@3.12.0.rbi",
    "sorbet/rbi/gems/rspec-expectations@3.12.0.rbi",
    "sorbet/rbi/gems/rspec-mocks@3.12.0.rbi",
    "sorbet/rbi/gems/rspec-support@3.12.0.rbi",
    "sorbet/rbi/gems/rspec@3.12.0.rbi",
    "sorbet/rbi/gems/rubocop-ast@1.28.0.rbi",
    "sorbet/rbi/gems/ruby-progressbar@1.13.0.rbi",
    "sorbet/rbi/gems/safe_type@1.1.1.rbi",
    "sorbet/rbi/gems/semver2@3.4.2.rbi",
    "sorbet/rbi/gems/simplecov-html@0.12.3.rbi",
    "sorbet/rbi/gems/simplecov@0.22.0.rbi",
    "sorbet/rbi/gems/simplecov_json_formatter@0.1.4.rbi",
    "sorbet/rbi/gems/sorbet-coerce@0.7.0.rbi",
    "sorbet/rbi/gems/spoom@1.2.1.rbi",
    "sorbet/rbi/gems/sqlite3@1.6.2.rbi",
    "sorbet/rbi/gems/stringio@3.0.2.rbi",
    "sorbet/rbi/gems/sync@0.5.0.rbi",
    "sorbet/rbi/gems/tapioca@0.11.4-a4319794491b54d9db1c06df7f3bdffcdf7bf684.rbi",
    "sorbet/rbi/gems/term-ansicolor@1.7.1.rbi",
    "sorbet/rbi/gems/thor@1.2.1.rbi",
    "sorbet/rbi/gems/thread_safe@0.3.6.rbi",
    "sorbet/rbi/gems/timecop@0.9.6.rbi",
    "sorbet/rbi/gems/tins@1.32.1.rbi",
    "sorbet/rbi/gems/tzinfo@2.0.6.rbi",
    "sorbet/rbi/gems/unicode-display_width@2.4.2.rbi",
    "sorbet/rbi/gems/unparser@0.6.7.rbi",
    "sorbet/rbi/gems/webrick@1.7.0.rbi",
    "sorbet/rbi/gems/yard-sorbet@0.8.1.rbi",
    "sorbet/rbi/gems/yard@0.9.28.rbi",
    "sorbet/rbi/gems/zeitwerk@2.6.7.rbi",
    "sorbet/rbi/models/acts-as-messageable/message.rbi",
    "sorbet/rbi/models/acts-as-messageable/user.rbi",
    "sorbet/rbi/rails-rbi/active_record_base.rbi",
    "sorbet/rbi/rails-rbi/active_record_relation.rbi",
    "sorbet/rbi/shims/activerecord.rbi",
    "sorbet/rbi/shims/model.rbi",
    "sorbet/tapioca/config.yml",
    "sorbet/tapioca/pre_require.rb",
    "sorbet/tapioca/require.rb",
    "spec/acts_as_messageable_spec.rb",
    "spec/custom_class_spec.rb",
    "spec/custom_required_spec.rb",
    "spec/group_messages_spec.rb",
    "spec/migrations_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/admin.rb",
    "spec/support/custom_message.rb",
    "spec/support/custom_message_uuid.rb",
    "spec/support/custom_search_user.rb",
    "spec/support/men.rb",
    "spec/support/send_message.rb",
    "spec/support/table_schema.rb",
    "spec/support/user.rb",
    "spec/support/uuid_user.rb",
    "tasks/types.rake"
  ]
  s.homepage = "http://github.com/LTe/acts-as-messageable".freeze
  s.rubygems_version = "3.4.1".freeze
  s.summary = "Make user messageable!;-)".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<activerecord>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<ancestry>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<railties>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<sorbet-rails>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<sorbet-static-and-runtime>.freeze, [">= 0"])
  s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
  s.add_development_dependency(%q<coveralls_reborn>.freeze, [">= 0"])
  s.add_development_dependency(%q<jeweler>.freeze, [">= 0"])
  s.add_development_dependency(%q<pg>.freeze, [">= 0"])
  s.add_development_dependency(%q<pry>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
  s.add_development_dependency(%q<rubocop-sorbet>.freeze, [">= 0"])
  s.add_development_dependency(%q<sord>.freeze, [">= 0"])
  s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
  s.add_development_dependency(%q<tapioca>.freeze, [">= 0"])
  s.add_development_dependency(%q<timecop>.freeze, [">= 0"])
  s.add_development_dependency(%q<unparser>.freeze, [">= 0"])
  s.add_development_dependency(%q<yard>.freeze, [">= 0"])
end

