# frozen_string_literal: true

require_relative 'lib/acts_as_messageable/version'

Gem::Specification.new do |s|
  s.name = 'acts-as-messageable'
  s.version = ActsAsMessageable::VERSION
  s.authors = ['Piotr Nielacny']
  s.email = 'piotr.nielacny@gmail.com'
  s.summary = 'Make user messageable!;-)'
  s.homepage = 'http://github.com/LTe/acts-as-messageable'
  s.license = 'MIT'
  s.metadata = { 'rubygems_mfa_required' => 'true' }

  s.required_rubygems_version = Gem::Requirement.new('>= 0')
  s.require_paths = ['lib']

  s.extra_rdoc_files = ['LICENSE', 'README.md']
  s.files = Dir['lib/**/*', 'LICENSE', 'README.md', 'Rakefile',
                'lib/generators/**/*', 'sorbet/**/*']

  s.add_dependency 'activerecord', '>= 0'
  s.add_dependency 'activesupport', '>= 0'
  s.add_dependency 'ancestry', '>= 0'
  s.add_dependency 'railties', '>= 0'
  s.add_dependency 'sorbet-rails', '>= 0'
  s.add_dependency 'sorbet-static-and-runtime', '>= 0'
  s.add_dependency 'zeitwerk', '>= 0'
end
