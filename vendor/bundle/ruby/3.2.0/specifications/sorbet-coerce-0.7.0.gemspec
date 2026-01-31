# -*- encoding: utf-8 -*-
# stub: sorbet-coerce 0.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sorbet-coerce".freeze
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chan Zuckerberg Initiative".freeze]
  s.date = "2019-10-04"
  s.email = "opensource@chanzuckerberg.com".freeze
  s.homepage = "https://github.com/chanzuckerberg/sorbet-coerce".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "A type coercion lib works with Sorbet's static type checker and type definitions; raises an error if the coercion fails.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<polyfill>.freeze, ["~> 1.8"])
  s.add_runtime_dependency(%q<safe_type>.freeze, ["~> 1.1", ">= 1.1.1"])
  s.add_runtime_dependency(%q<sorbet-runtime>.freeze, [">= 0.4.4704"])
  s.add_development_dependency(%q<sorbet>.freeze, [">= 0.4.4704"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8", ">= 3.8"])
  s.add_development_dependency(%q<byebug>.freeze, ["~> 11.0.1", ">= 11.0.1"])
end
