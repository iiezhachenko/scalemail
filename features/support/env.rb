require 'simplecov'
SimpleCov.command_name 'features'

require 'aruba/cucumber'
require 'methadone/cucumber'

path = File.expand_path(File.dirname(__FILE__) + '/../../bin')
ENV['PATH'] = "#{path}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
current_folder = File.expand_path(File.dirname(__FILE__))
LIB_DIR ||= File.join(current_folder, '..', '..', 'lib')

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
  ENV['COVERAGE'] = 'true'
end

After do
  ENV['RUBYLIB'] = @original_rubylib
end
