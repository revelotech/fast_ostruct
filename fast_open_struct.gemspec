# frozen_string_literal: true

require_relative 'lib/fast_open_struct'

Gem::Specification.new do |spec|
  spec.name        = 'fast_open_struct'
  spec.version     = FastOpenStruct::VERSION
  spec.authors     = ['Washington Silva']
  spec.email       = ['w-osilva@hotmail.com']
  spec.homepage    = 'https://github.com/w-osilva/fast_open_struct'
  spec.summary     = 'A realy fast open struct alternative'
  spec.licenses    = ['MIT']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['github_repo'] = spec.homepage

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'benchmark-ips', '>= 2'
  spec.add_development_dependency 'pry', '>= 0.14'
  spec.add_development_dependency 'rack-test', '~> 1.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.25'
  spec.add_development_dependency 'rubocop-performance', '~> 1.15'

  spec.add_dependency 'json', '>= 2'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
