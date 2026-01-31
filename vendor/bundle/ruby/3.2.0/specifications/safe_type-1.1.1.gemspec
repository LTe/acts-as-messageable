# -*- encoding: utf-8 -*-
# stub: safe_type 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "safe_type".freeze
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Donald Dong".freeze, "Edmund Loo".freeze, "Jacob Gable".freeze]
  s.date = "2018-07-18"
  s.description = " \n    Type Coercion & Type Enhancement\n  ".freeze
  s.email = ["mail@ddong.me".freeze, "edmundloo@outlook.com".freeze, "jgable@chanzuckerberg.com".freeze]
  s.homepage = "https://github.com/chanzuckerberg/safe_type".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Type Coercion & Type Enhancement".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 12.3"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8"])
end
