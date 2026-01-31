lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'polyfill/version'

Gem::Specification.new do |spec|
  spec.name    = 'polyfill'
  spec.version = Polyfill::VERSION
  spec.authors = ['Aaron Lasseigne']
  spec.email   = ['aaron.lasseigne@gmail.com']

  spec.summary  = 'Adds newer Ruby methods to older versions.'
  spec.homepage = ''
  spec.license  = 'MIT'

  spec.required_ruby_version = '>= 2.1'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'rubocop', '~> 0.57.0' # highest supporting 2.1
end
