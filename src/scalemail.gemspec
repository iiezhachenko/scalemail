Gem::Specification.new do |s|
  s.name        = 'scalemail'
  s.version     = '0.1.0'
  s.summary     = 'Application scaling framework'
  s.description = 'Framework for microservises scaling using Docker and cloud platforms.'
  s.authors     = ['Ievgen Iezhachenko']
  s.email       = 'ievgen.iezhachenko@gmail.com'
  s.files = Dir['lib/*.rb'] + Dir['bin/*']
  s.files += Dir['[A-Z]*'] + Dir['spec/**/*']
  s.homepage    = 'https://github.com/iiezhachenko/scalemail'
  s.license     = 'MIT'
  s.executables << 'scalemail'
end