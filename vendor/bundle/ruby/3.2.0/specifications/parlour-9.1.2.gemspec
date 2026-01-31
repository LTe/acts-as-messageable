# -*- encoding: utf-8 -*-
# stub: parlour 9.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "parlour".freeze
  s.version = "9.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aaron Christiansen".freeze]
  s.bindir = "exe".freeze
  s.date = "2025-07-07"
  s.email = ["hello@aaronc.cc".freeze]
  s.executables = ["parlour".freeze]
  s.files = ["exe/parlour".freeze]
  s.homepage = "https://github.com/AaronC81/parlour".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.20".freeze
  s.summary = "A type information generator, merger and parser for Sorbet and Ruby 3/Steep".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<sorbet-runtime>.freeze, [">= 0.5"])
  s.add_runtime_dependency(%q<rainbow>.freeze, ["~> 3.0"])
  s.add_runtime_dependency(%q<commander>.freeze, ["~> 5.0"])
  s.add_runtime_dependency(%q<parser>.freeze, [">= 0"])
  s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 12.3.3"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
  s.add_development_dependency(%q<sorbet>.freeze, [">= 0"])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
  s.add_development_dependency(%q<yard>.freeze, [">= 0"])
end
