require 'rubygems'
require 'bundler'
require 'rspec/core/rake_task'
require 'yard'

Bundler::GemHelper.install_tasks

YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb' ]
  t.options += [ '--title', "RCAP - Common Alerting Protocol for Ruby" ]
  t.options += [ '--main', 'README.md']
  t.options += [ '--files', 'CHANGELOG.md' ]
  t.options += [ '--output-dir', 'doc' ]
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
