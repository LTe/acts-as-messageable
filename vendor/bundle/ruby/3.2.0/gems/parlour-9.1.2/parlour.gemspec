
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "parlour/version"

Gem::Specification.new do |spec|
  spec.name          = "parlour"
  spec.version       = Parlour::VERSION
  spec.authors       = ["Aaron Christiansen"]
  spec.email         = ["hello@aaronc.cc"]

  spec.summary       = %q{A type information generator, merger and parser for Sorbet and Ruby 3/Steep}
  spec.homepage      = "https://github.com/AaronC81/parlour"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|sorbet|rbi)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "sorbet-runtime", ">= 0.5"
  spec.add_dependency "rainbow", "~> 3.0"
  spec.add_dependency "commander", "~> 5.0"
  spec.add_dependency "parser"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "sorbet"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "yard"
end
