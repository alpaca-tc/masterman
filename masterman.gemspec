lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'masterman/version'

Gem::Specification.new do |spec|
  spec.name = 'masterman'
  spec.version = Masterman::VERSION
  spec.authors = ['alpaca-tc']
  spec.email = ['alpaca-tc@alpaca.tc']

  spec.summary = %q{Masterman is static data loader for Ruby.}
  spec.description = %q{Masterman is static data loader for Ruby. It loads data from direct or file, and defines accessor to read attributes.}
  spec.homepage = 'https://github.com/alpaca-tc/masterman'
  spec.license = 'MIT'
  spec.require_paths = ['lib']

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.add_runtime_dependency 'activesupport', '~> 4.2'
  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  spec.add_development_dependency 'pry', '~> 0.9', '>= 0.9.12'
  spec.add_development_dependency 'guard', '~> 2.13', '>= 2.13.0'
  spec.add_development_dependency 'guard-rspec', '~> 4.6', '>= 4.6.4'
end
