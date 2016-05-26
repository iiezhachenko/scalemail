require 'bundler'
require 'rake/clean'
require 'cucumber'
require 'cucumber/rake/task'
gem 'rdoc' # we need the installed RDoc gem, not the system one
require 'rdoc/task'

begin
  require 'rspec/core/rake_task'
rescue LoadError
  dump_load_path
  raise
end

include Rake::DSL

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new do
  # Put spec opts in a file named .rspec in root
end

CUKE_RESULTS = 'results.html'.freeze
CLEAN << CUKE_RESULTS
Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} "\
                    '--format pretty --no-source -x'
  t.fork = false
end

Rake::RDocTask.new do |rd|
  rd.main = 'README.rdoc'
  rd.rdoc_files.include('README.rdoc', 'lib/**/*.rb', 'bin/**/*')
end

task default: [:spec, :features]

def dump_load_path
  puts $LOAD_PATH.join("\n")
  found = nil
  $LOAD_PATH.each do |path|
    next unless File.exist?(File.join(path, 'rspec'))
    puts "Found rspec in #{path}"
    found = check_rspec_folder path
  end
  puts_path_search_result(found)
end

def check_rspec_folder(path)
  if File.exist?(File.join(path, 'rspec', 'core'))
    puts 'Found core'
    find_rake_task(found)
  else
    puts '!!! no core'
  end
end

def find_rake_task(found)
  if File.exist?(File.join(path, 'rspec', 'core', 'rake_task'))
    puts 'Found rake_task'
    return found
  else
    puts '!! no rake_task'
  end
end

def puts_path_search_result(found)
  if found.nil?
    puts "Didn't find rspec/core/rake_task anywhere"
  else
    puts "Found in #{path}"
  end
end
