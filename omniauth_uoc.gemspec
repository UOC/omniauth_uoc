# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth_uoc/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth_uoc'
  spec.version       = OmniauthUoc::VERSION
  spec.authors       = ['rromerogar']
  spec.email         = ['rromerogar@uoc.edu']
  spec.summary       = %q{ OmniAuth provider that supports authentication against UOC REST apis. }
  spec.homepage      = 'http://github.com/rromerogar/omniauth_uoc'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_dependency 'omniauth', '~> 1.0'
  spec.add_dependency 'multi_xml', '~> 0.5.5'
  spec.add_dependency 'faraday', '~> 0.9.0'
end
