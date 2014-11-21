# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crichton_test_service/version'

Gem::Specification.new do |spec|
  spec.name          = "crichton_test_service"
  spec.version       = CrichtonTestService::VERSION
  spec.authors       = ["Connor Savage"]
  spec.email         = ["csavage@mdsol.com"]
  spec.summary       = %q{Write a short summary. Required.}
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
  spec.add_development_dependency 'rspec-rails', '~> 3.1'
  spec.add_development_dependency 'faraday'
  spec.add_development_dependency 'pry'

  # TODO: add dependencies on Crichton and Representors when hosted off git.
  # TODO: make it clear in README.md that this gem should only be listed as a development dependency
  # These dependencies need to include the gems listed in the rails project Gemfile.
  spec.add_dependency "rails", '3.2'
  spec.add_dependency "activesupport", '<= 4.0'
  spec.add_dependency 'launchy'
  spec.add_dependency 'sqlite3'
  spec.add_dependency 'rack'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'yajl-ruby', '~> 1.2.0'
end
