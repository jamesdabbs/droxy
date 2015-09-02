# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'droxy/version'

Gem::Specification.new do |spec|
  spec.name          = "droxy"
  spec.version       = Droxy::VERSION
  spec.authors       = ["James Dabbs"]
  spec.email         = ["jamesdabbs@gmail.com"]
  spec.summary       = %q{Like pow, but for docker machines}
  spec.description   = %q{A small DNS server and resolver hook to route machine.dock tp $(docker-machine ip machine)}
  spec.homepage      = "https://github.com/jamesdabbs/droxy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize"
  spec.add_dependency "rubydns", "~> 1.0"
  spec.add_dependency "thor",    "~> 0.19"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
