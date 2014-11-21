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

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  # TODO: add dependencies on Crichton and Representors when hosted off git.
  spec.add_dependency 'faraday'

  # These dependencies need to include the gems listed in the rails project Gemfile.
  # TODO: make it clear in README.md that this gem should only be listed as a development dependency
  spec.add_dependency "rails", '3.2'
  spec.add_dependency "activesupport", '<= 4.0'
  spec.add_dependency "rspec-rails", '2.99'
  spec.add_dependency 'launchy'
  spec.add_dependency 'sqlite3'
  spec.add_dependency 'rack'
  spec.add_dependency 'jquery-rails'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'yajl-ruby', '~> 1.2.0'
end
