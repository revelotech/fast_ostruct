# frozen_string_literal: true

require_relative 'lib/fast_ostruct'

Gem::Specification.new do |spec|
  spec.name        = 'fast_ostruct'
  spec.version     = FastOpenStruct::VERSION
  spec.authors     = ['Revelo']
  spec.email       = ['devs@revelo.com']
  spec.homepage    = 'https://github.com/revelotech/fast_ostruct'
  spec.summary     = 'An OpenStruct alternative focused on performance.'
  spec.licenses    = ['MIT']

  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['github_repo'] = spec.homepage

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'json', '>= 2'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
