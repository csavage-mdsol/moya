# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'moya/version'

Gem::Specification.new do |spec|
  spec.name          = "moya"
  spec.version       = Moya::VERSION
  spec.authors       = ["Connor Savage", "Shea Valentine"]
  spec.email         = ["csavage@mdsol.com", "svalentine@mdsol.com"]
  spec.summary       = %q{Exposes methods for launching a hypermedia capable service as a background process, or requiring its files, for the purposes of testing}
  spec.description   = %q{Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'faraday'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'activeuuid'

  # TODO: add dependencies on Crichton and Representors when hosted off git.
  # TODO: make it clear in README.md that this gem should only be listed as a development dependency
  # These dependencies need to include the gems listed in the rails project Gemfile.
  spec.add_dependency 'rails', '4.0.8'
  spec.add_dependency 'launchy'
  spec.add_dependency 'sqlite3'
  spec.add_dependency 'rack'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'yajl-ruby', '~> 1.2.0'
end
