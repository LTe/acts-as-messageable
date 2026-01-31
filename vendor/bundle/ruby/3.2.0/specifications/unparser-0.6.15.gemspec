# -*- encoding: utf-8 -*-
# stub: unparser 0.6.15 ruby lib

Gem::Specification.new do |s|
  s.name = "unparser".freeze
  s.version = "0.6.15"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/mbj/unparser/issues", "changelog_uri" => "https://github.com/mbj/unparser/blob/master/Changelog.md", "funding_uri" => "https://github.com/sponsors/mbj", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/mbj/unparser" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Markus Schirp".freeze]
  s.date = "2024-06-15"
  s.description = "Generate equivalent source for parser gem AST nodes".freeze
  s.email = "mbj@schirp-dso.com".freeze
  s.executables = ["unparser".freeze]
  s.extra_rdoc_files = ["README.md".freeze]
  s.files = ["README.md".freeze, "bin/unparser".freeze]
  s.homepage = "http://github.com/mbj/unparser".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Generate equivalent source for parser gem AST nodes".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<diff-lcs>.freeze, ["~> 1.3"])
  s.add_runtime_dependency(%q<parser>.freeze, [">= 3.3.0"])
  s.add_development_dependency(%q<mutant>.freeze, ["~> 0.12.2"])
  s.add_development_dependency(%q<mutant-rspec>.freeze, ["~> 0.12.2"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.9"])
  s.add_development_dependency(%q<rspec-core>.freeze, ["~> 3.9"])
  s.add_development_dependency(%q<rspec-its>.freeze, ["~> 1.3.0"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.7"])
  s.add_development_dependency(%q<rubocop-packaging>.freeze, ["~> 0.5"])
end
