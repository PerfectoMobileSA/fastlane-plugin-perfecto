# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/perfecto/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-perfecto'
  spec.version       = Fastlane::Perfecto::VERSION
  spec.author        = 'Perfecto'
  spec.email         = 'support@perfectomobile.com'

  spec.summary       = 'This plugin allows you to automatically upload ipa/apk files to Perfecto for manual/automation testing'
  spec.homepage      = "https://github.com/PerfectoMobileSA/fastlane-plugin-perfecto"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency('pry')
  spec.add_development_dependency('bundler')
  spec.add_development_dependency('rspec')
  spec.add_development_dependency('rspec_junit_formatter')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop', '0.49.1')
  spec.add_development_dependency('rubocop-require_tools')
  spec.add_development_dependency('simplecov')
  spec.add_development_dependency('fastlane', '>= 2.139.0')
  spec.add_runtime_dependency('rest-client', '~> 2.0', '>= 2.0.2')
end
