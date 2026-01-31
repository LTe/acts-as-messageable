Gem::Specification.new do |s|
  s.name        = 'safe_type'
  s.version     = '1.1.1'
  s.date        = '2018-07-18'
  s.summary     = 'Type Coercion & Type Enhancement'
  s.description = %q{ 
    Type Coercion & Type Enhancement
  }
  s.authors     = ['Donald Dong', 'Edmund Loo', 'Jacob Gable']
  s.email       = ['mail@ddong.me', 'edmundloo@outlook.com', 'jgable@chanzuckerberg.com']
  s.homepage    = 'https://github.com/chanzuckerberg/safe_type'
  s.license     = 'MIT'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) } - ['bin/console', 'bin/setup']

  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.16'
  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rspec', '~> 3.8'

end
