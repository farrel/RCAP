require 'bundler'
require 'hanna/rdoctask'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

Rake::RDocTask.new do |rdoc|
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc', 'CHANGELOG.rdoc', 'lib/**/*.rb')
  rdoc.rdoc_dir = 'doc'
  rdoc.title = 'RCAP Ruby API'
end

RSpec::Core::RakeTask.new do |spec|
  spec.rspec_opts = ['--options spec/spec.opts']
end

desc 'Generate a new tag file'
task :tags do |t|
  Kernel.system('ctags --recurse lib/*')
end

task :default => :spec
