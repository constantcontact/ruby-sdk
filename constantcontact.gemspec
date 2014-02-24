# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name = "constantcontact"
  s.version = '1.1.2'
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
  s.test_files = Dir['spec/**/*_spec.rb']
  
  s.add_runtime_dependency("rest-client", '~> 1.6', '>= 1.6.7')
  s.add_runtime_dependency("json", '~> 1.8', '>= 1.8.1')
  s.add_runtime_dependency('mime-types', '~> 1.25', '>= 1.25.1')
  s.add_development_dependency("rspec", '~> 2.14')
end