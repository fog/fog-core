# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/core/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-core"
  spec.version       = Fog::VERSION
  spec.authors       = ["Evan Light"]
  spec.email         = ["evan@tripledogdare.net"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  s.add_dependency('builder')
  s.add_dependency('excon', '~>0.31.0')
  s.add_dependency('formatador', '~>0.2.0')
  s.add_dependency('multi_json', '~>1.0')
  s.add_dependency('mime-types')
  s.add_dependency('net-scp', '~>1.1')
  s.add_dependency('net-ssh', '>=2.1.3')
  s.add_dependency('nokogiri', '>=1.5.11')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  s.add_development_dependency('jekyll') unless RUBY_PLATFORM == 'java'
  s.add_development_dependency('rake')
  s.add_development_dependency('rbvmomi')
  s.add_development_dependency('yard')
  s.add_development_dependency('thor')
  s.add_development_dependency('rbovirt', '>=0.0.11')
  s.add_development_dependency('shindo', '~>0.3.4')
  s.add_development_dependency('fission')
  s.add_development_dependency('pry')
  s.add_development_dependency('google-api-client', '~>0.6.2')
  s.add_development_dependency('unf')
  if ENV["FOG_USE_LIBVIRT"] && RUBY_PLATFORM != 'java'
    s.add_development_dependency('ruby-libvirt','~>0.4.0')
  end

end
