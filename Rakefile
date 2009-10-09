require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rcov/rcovtask'

SPEC = Gem::Specification.new do |gem|
  gem.name = "rcap"
  gem.version = "0.1"
  gem.author = "Farrel Lifson"
  gem.email = "farrel.lifson@aimred.com"
  gem.homepage = "http://www.aimred.com/projects/rcap"
  gem.platform = Gem::Platform::RUBY
  gem.summary = "CAP(Common Alerting Protocol) API"
  gem.files = Dir.glob("{lib,examples}/**/*")
  gem.require_path = "lib"
  gem.has_rdoc = true
  gem.extra_rdoc_files = [ "README","CHANGELOG" ]
  gem.add_dependency( 'assistance' )
end

Rake::GemPackageTask.new(SPEC) do |pkg|
  pkg.need_tar = true
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README"
  rdoc.rdoc_files.include( "README", "CHANGELOG", "lib/**/*.rb" )
  rdoc.rdoc_dir = "doc"
end

task( :load_environment ) do

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
