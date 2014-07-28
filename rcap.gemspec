# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('../lib', __FILE__)
require 'rcap/version'

Gem::Specification.new do |s|
  s.name        = 'rcap'
  s.version     = RCAP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Farrel Lifson']
  s.email       = ['farrel.lifson@aimred.com']
  s.homepage    = 'http://www.aimred.com/projects/rcap'
  s.summary     = 'CAP(Common Alerting Protocol) API'
  s.description = 'A Ruby API providing parsing, generation and validation of CAP(Common Alerting Protocol) messages.'

  s.rubyforge_project = 'rcap'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.extra_rdoc_files = ['README.md','CHANGELOG.md']
  s.add_dependency('json', '>= 1.5.1')
  s.add_dependency('uuidtools', '>= 2.1.2')

  s.add_development_dependency( 'rspec', '>= 2.5.0' )
  s.add_development_dependency( 'yard' )
  s.add_development_dependency( 'webmock' )
end
