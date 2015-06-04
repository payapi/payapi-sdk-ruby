# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'payapi/version'

Gem::Specification.new do |spec|
  spec.name          = 'payapi'
  spec.version       = Payapi::VERSION
  spec.authors       = ['PayApi dev team']
  spec.email         = ['devteam@payapi.io']

  spec.summary       = %q{Simple client for PayApi http://payapi.io/}
  spec.description   = %q{Proof of concept REST client.}
  spec.homepage      = 'http://payapi.io'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rest-client'
  spec.add_dependency 'jwt'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.6'
  spec.add_development_dependency 'webmock', '~> 1.21'
end
