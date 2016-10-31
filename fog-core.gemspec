# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fog/core/version"

Gem::Specification.new do |spec|
  spec.name          = "fog-core"
  spec.version       = Fog::Core::VERSION
  spec.authors       = ["Evan Light", "Wesley Beary"]
  spec.email         = ["evan@tripledogdare.net", "geemus@gmail.com"]
  spec.summary       = "Shared classes and tests for fog providers and services."
  spec.description   = "Shared classes and tests for fog providers and services."
  spec.homepage      = "https://github.com/fog/fog-core"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency("builder")
  spec.add_dependency("excon", "~> 0.49")
  spec.add_dependency("formatador", "~> 0.2")

  spec.add_development_dependency("coveralls")
  spec.add_development_dependency("fog-mock", "~> 0.1")
  spec.add_development_dependency("minitest")
  spec.add_development_dependency("minitest-stub-const")
  spec.add_development_dependency("pry")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("rubocop") if RUBY_VERSION.to_s >= "1.9.3"
  spec.add_development_dependency("thor")
  spec.add_development_dependency("yard")
end
