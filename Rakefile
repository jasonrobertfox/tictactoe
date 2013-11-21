# Encoding: utf-8

require 'rubocop/rake_task'
require 'rspec/core/rake_task'

task default: :build

task build: [:clean, :prepare, :quality, :unit, :system]

desc 'Runs standard build activities.'
task build_full: [:build]

desc 'Runs quality checks.'
task quality: [:rubocop]

Rubocop::RakeTask.new

desc 'Removes the build directory.'
task :clean do
  FileUtils.rm_rf 'build'
end
desc 'Creates a basic build directory.'
task :prepare do
  FileUtils.mkdir_p('build/spec')
end

def get_rspec_flags(log_name, others = nil)
  "--format documentation --out build/spec/#{log_name}.log --format html --out build/spec/#{log_name}.html --format progress #{others}"
end

RSpec::Core::RakeTask.new(:unit) do |t|
  ENV['TEST_TYPE'] = 'unit'
  ENV['COVERAGE'] = 'true'
  t.pattern = FileList['spec/unit/**/*_spec.rb']
  t.rspec_opts = get_rspec_flags('unit')
end

RSpec::Core::RakeTask.new(:system) do |t|
  ENV['TEST_TYPE'] = 'system'
  t.pattern = FileList['spec/system/**/*_spec.rb']
  t.rspec_opts = get_rspec_flags('system')
end
