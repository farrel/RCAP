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

desc 'Clean up whitespace across the entire application (strip trailing whitespace and convert tab => 2 spaces).'
task :whitespace do
  require 'rbconfig'
  if Config::CONFIG['host_os'] =~ /linux/
    sh %{find . -name '*.*rb' -exec sed -i 's/\t/  /g' {} \\; -exec sed -i 's/ *$//g' {} \\; }
  elsif Config::CONFIG['host_os'] =~ /darwin/
    sh %{find . -name '*.*rb' -exec sed -i '' 's/\t/  /g' {} \\; -exec sed -i '' 's/ *$//g' {} \\; }
  else
    puts "This doesn't work on systems other than OSX or Linux. Please use a custom whitespace tool for your platform '#{Config::CONFIG["host_os"]}'."
  end
end

task :default => :spec
