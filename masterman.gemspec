lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'masterman/version'

Gem::Specification.new do |spec|
  spec.name = 'masterman'
  spec.version = Masterman::VERSION
  spec.authors = ['alpaca-tc']
  spec.email = ['alpaca-tc@alpaca.tc']

  spec.summary = %q{TODO: Write a short summary, because Rubygems requires one.}
  spec.description = %q{TODO: Write a longer description or delete this line.}
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_dependency 'activemodel'
end
