# -*- encoding: utf-8 -*-
# stub: polyfill 1.9.0 ruby lib

Gem::Specification.new do |s|
  s.name = "polyfill".freeze
  s.version = "1.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aaron Lasseigne".freeze]
  s.bindir = "exe".freeze
  s.date = "2020-12-12"
  s.email = ["aaron.lasseigne@gmail.com".freeze]
  s.homepage = "".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Adds newer Ruby methods to older versions.".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<rake>.freeze, ["~> 12.3"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.57.0"])
end
