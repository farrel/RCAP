# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'rcap/version'

Gem::Specification.new do |s|
  s.name        = 'rcap'
  s.version     = RCAP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Farrel Lifson']
  s.email       = ['farrel.lifson@aimred.com']
  s.homepage    = 'http://www.aimred.com/projects/rcap'
  s.summary     = %q{CAP(Common Alerting Protocol) API}
  s.description = %q{A Ruby API providing parsing and generation of CAP(Common Alerting Protocol) messages.}

  s.rubyforge_project = 'rcap'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','CHANGELOG.rdoc']
  s.add_dependency('assistance')
  s.add_dependency('json')
  s.add_dependency('uuidtools', '>= 2.0.0')

  s.add_development_dependency('rspec', '~> 1.3.1')
  s.add_development_dependency('hanna')
end
