require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'rcov/rcovtask'

SPEC = Gem::Specification.new do |spec|
  spec.name = "rCAP"
  spec.version = "0.1"
  spec.author = "Farrel Lifson"
  spec.email = "farrel.lifson@aimred.com"
  spec.homepage = "http://www.aimred.com/projects/rcap"
  spec.platform = Gem::Platform::RUBY
  spec.summary = "CAP(Common Alerting Protocol) API"
  spec.files = Dir.glob("{lib,examples}/**/*")
  spec.require_path = "lib"
  spec.autorequire = "rcap"
  spec.has_rdoc = true
  spec.extra_rdoc_files = [ "README","CHANGELOG" ]
  spec.add_dependency( 'assistance' )
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
end
