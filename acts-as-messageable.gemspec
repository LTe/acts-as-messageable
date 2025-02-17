# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'acts_as_messageable/version'

Gem::Specification.new do |spec|
  spec.name = 'acts-as-messageable'
  spec.version = ActsAsMessageable::VERSION

  spec.authors = ['Piotr Nielacny']
  spec.email = 'piotr.nielacny@gmail.com'
  spec.files = Dir.glob('lib/**/*.rb') + ['README.md', 'LICENSE']
  spec.homepage = 'http://github.com/LTe/acts-as-messageable'
  spec.license = 'MIT'
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.1'
  spec.summary = 'Make user messageable!'

  spec.add_dependency('activerecord', ['>= 7.0'])
  spec.add_dependency('ancestry', ['>= 4.3'])
  spec.add_dependency('sorbet-static-and-runtime', ['>= 0.5'])

  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
end
