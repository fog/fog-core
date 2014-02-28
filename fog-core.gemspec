# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-core"
  spec.version       = Fog::VERSION
  spec.authors       = ["Evan Light", "Wesley Beary"]
  spec.email         = ["evan@tripledogdare.net", "geemus@gmail.com"]
  spec.summary       = %q{Shared classes and tests for fog providers and services.}
  spec.description   = %q{Shared classes and tests for fog providers and services.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir.glob(File.join("lib", "**", "*.rb"))
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('builder')
  spec.add_dependency('excon', '~>0.31.0')
  spec.add_dependency('formatador', '~>0.2.0')
  spec.add_dependency('mime-types')
  spec.add_dependency('net-scp', '~>1.1')
  spec.add_dependency('net-ssh', '>=2.1.3')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  spec.add_development_dependency('rake')
  spec.add_development_dependency('yard')
  spec.add_development_dependency('thor')
  spec.add_development_dependency('shindo', '~>0.3.4')
  spec.add_development_dependency('faraday')
  spec.add_development_dependency('vcr')
  spec.add_development_dependency('minitest-vcr')
  spec.add_development_dependency('webmock')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('coveralls')
end
