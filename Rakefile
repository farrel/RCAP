require 'rake/gempackagetask'
require 'hanna/rdoctask'
require 'spec/rake/spectask'

SPEC = Gem::Specification.new do |gem|
  gem.name = "rcap"
  gem.version = "0.3"
  gem.authors = [ "Farrel Lifson" ]
  gem.email = "farrel.lifson@aimred.com"
  gem.homepage = "http://www.aimred.com/projects/rcap"
  gem.platform = Gem::Platform::RUBY
  gem.summary = "CAP(Common Alerting Protocol) API"
  gem.files = Dir.glob("{lib,examples}/**/*")
  gem.require_path = "lib"
  gem.has_rdoc = true
  gem.extra_rdoc_files = [ "README.rdoc","CHANGELOG.rdoc" ]
  gem.add_dependency( 'assistance' )
  gem.add_dependency( 'uuidtools', '>= 2.0.0' )
  gem.description = "A Ruby API providing parsing and generation of CAP(Common Alerting Protocol) messages."
  gem.test_files = Dir.glob("spec/*.rb")
end

Rake::GemPackageTask.new(SPEC) do |pkg|
  pkg.need_tar = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README"
  rdoc.rdoc_files.include( "README.rdoc", "CHANGELOG.rdoc", "lib/**/*.rb" )
  rdoc.rdoc_dir = "doc"
  rdoc.title = "RCAP Ruby API"
end

Spec::Rake::SpecTask.new do |spec|
  spec.libs = ['lib']
  spec.warning = true
  spec.spec_opts = ['--options spec/spec.opts']
end

desc( 'Generate a new tag file' )
task( :tags ) do |t|
  Kernel.system( 'ctags --recurse lib/* ')
end
