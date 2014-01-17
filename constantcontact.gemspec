# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'constantcontact/version'

Gem::Specification.new do |s|
  s.name = "constantcontact"
  s.version = ConstantContact::SDK::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["ConstantContact"]
  s.homepage = "http://www.constantcontact.com"
  s.summary = %q{Constant Contact SDK for Ruby}
  s.email = "apisupport@constantcontact.com"
  s.description = "Ruby library for interactions with Constant Contact v2 API"
  s.license = "MIT"

  s.files = [
    '.rspec',
    'constantcontact.gemspec',
    'README.md'
  ]
  s.files += Dir['lib/**/*.rb']
  s.executables = []
  s.require_paths = [ "lib" ]
  s.test_files = Dir['spec/**/*.rb']
  
  s.add_dependency("rest-client")
  s.add_dependency("json")
  s.add_dependency('mime-types', ['1.25.1'])
  s.add_development_dependency("rspec")
end