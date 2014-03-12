# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'SyndicatePlusApi/version'

Gem::Specification.new do |spec|
  spec.name          = "SyndicatePlusApi"
  spec.version       = SyndicatePlusApi::VERSION
  spec.authors       = ["Babasaheb Gosavi"]
  spec.email         = ["ppuri54@gmail.com"]
  spec.summary       = %q{Syndicate API for SyndicateApi Gem}
  spec.description   = %q{Syndicate API for SyndicateApi Gem for Fetching Details}
  spec.homepage      = "http://www.syndicateplus.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", '~> 0'

  spec.add_runtime_dependency 'crack','~> 0.3' 
  spec.add_runtime_dependency 'hashie', '~> 1.1'
  spec.add_runtime_dependency 'confiture', '~> 0.1'
  spec.add_runtime_dependency 'uuid', '~> 2.3', '>= 2.3.7'
  spec.add_runtime_dependency 'rest-client', '~> 1.6.7', '>= 1.6.7'
  spec.add_runtime_dependency 'json','~> 1.8', '>= 1.8.1'
  spec.add_runtime_dependency('jruby-openssl') if RUBY_PLATFORM == 'java'
end
