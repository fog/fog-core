# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/version'

Gem::Specification.new do |spec|
  spec.name          = "fog-core"
  spec.version       = Fog::VERSION
  spec.authors       = ["Evan Light"]
  spec.email         = ["evan@tripledogdare.net"]
  spec.summary       = %q{}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir.glob(File.join("lib", "**", "*.rb"))
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('builder')
  spec.add_dependency('excon', '~>0.31.0')
  spec.add_dependency('formatador', '~>0.2.0')
  spec.add_dependency('multi_json', '~>1.0')
  spec.add_dependency('mime-types')
  spec.add_dependency('net-scp', '~>1.1')
  spec.add_dependency('net-ssh', '>=2.1.3')
  spec.add_dependency('nokogiri', '>=1.5.11')

  ## List your development dependencies here. Development dependencies are
  ## those that are only needed during development
  spec.add_development_dependency('jekyll') unless RUBY_PLATFORM == 'java'
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rbvmomi')
  spec.add_development_dependency('yard')
  spec.add_development_dependency('thor')
  spec.add_development_dependency('rbovirt', '>=0.0.11')
  spec.add_development_dependency('shindo', '~>0.3.4')
  spec.add_development_dependency('fission')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('google-api-client', '~>0.6.2')
  spec.add_development_dependency('unf')
  if ENV["FOG_USE_LIBVIRT"] && RUBY_PLATFORM != 'java'
    spec.add_development_dependency('ruby-libvirt','~>0.4.0')
  end

end
