require 'bundler'
require 'hanna/rdoctask'
require 'spec/rake/spectask'

Bundler::GemHelper.install_tasks

Rake::RDocTask.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'CHANGELOG.rdoc', 'lib/**/*.rb')
  rdoc.rdoc_dir = 'doc'
  rdoc.title = 'RCAP Ruby API'
end

Spec::Rake::SpecTask.new do |spec|
  spec.libs = ['lib','spec']
  spec.warning = true
  spec.spec_opts = ['--options spec/spec.opts']
end

desc 'Generate a new tag file'
task :tags do |t|
  Kernel.system('ctags --recurse lib/*')
end

task :default => :spec
