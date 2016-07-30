# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "include_module"
  spec.version       = "0.1.0"
  spec.authors       = ["exAspArk"]
  spec.email         = ["exaspark@gmail.com"]

  spec.summary       = %q{Include your modules explicitly}
  spec.description   = %q{Include your modules explicitly}
  spec.homepage      = "https://github.com/exAspArk/include_module"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.1'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.9"
  spec.add_development_dependency "pry-byebug", "~> 3.4"
  spec.add_development_dependency "m", "~> 1.5"
end
