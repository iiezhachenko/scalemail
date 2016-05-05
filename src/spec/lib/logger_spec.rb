require 'rspec'
require_relative '../../lib/logger'

describe Logger do
  before() do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end
  after(:all) do
    $stdout = STDOUT
    $stderr = STDERR
  end

  it 'should print timestamped message in STDOUT' do
    Class.new.extend(Logger).formatted_log_to_stdout('prefix', 'string')
    stdout_value = $stdout.string
    expect(stdout_value).to match(/\d{2}:\d{2}:\d{2} prefix string/)
  end
  it 'should print message without timestamp in STDOUT' do
    Class.new.extend(Logger).formatted_log_to_stdout('prefix', 'string', false)
    stdout_value = $stdout.string
    expect(stdout_value).to match('prefix string')
  end
  it 'should print timestamped message in STDERR' do
    #TODO: fix
    # Class.new.extend(Logger).formatted_log_to_stderr('prefix', 'string')
    # stderr_value = $stderr.string
    # expect(stderr_value).to match(/\d{2}:\d{2}:\d{2} prefix string/)
  end
  it 'should print message without timestamp in STDERR' do
    #TODO: fix
    # Class.new.extend(Logger).formatted_log_to_stderr('prefix', 'string', false)
    # stderr_value = $stderr.string
    # expect(stderr_value).to match('prefix string')
  end

end