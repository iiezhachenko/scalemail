# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scalemail/version'

Gem::Specification.new do |spec|
  spec.name = 'scalemail'
  spec.license = 'mit'
  spec.version = Scalemail::VERSION
  spec.authors = ['Ievgen Iezhachenko']
  spec.email = ['ievgen.iezhachenko@gmail.com']

  spec.summary = 'Docker Machine infrastructure management application'
  spec.description = 'CLI application which allows to create Docker Machine
    infrastructure in declarative way through simple YAML config file.'
  spec.homepage = 'https://github.com/iiezhachenko/scalemail'

  # Prevent pushing this gem to RubyGems.org.
  # To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host
  # or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer
      is required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`
               .split("\x0")
               .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('pry-stack_explorer')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('pry')
  spec.add_dependency('methadone', '~> 1.9.2')
  spec.add_development_dependency('test-unit')
  spec.add_development_dependency('rspec', '~> 3')
end
