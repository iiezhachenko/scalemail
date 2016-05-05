require 'rspec'
require_relative '../../lib/utils'

describe Utils do
  before() do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end
  after(:all) do
    $stdout = STDOUT
    $stderr = STDERR
  end

  it 'should print command output to STDOUT on UNIX systems if stdout_streaming enabled' do
    if File.exist? '/usr'
      Class.new.extend(Utils).run_os_command('host', 'echo test')
      stdout_value = $stdout.string
      expect(stdout_value).to match(/\d{2}:\d{2}:\d{2} OUT \[host\] test/)
    else
      skip('Skipped because OS in not UNIX')
    end
  end
  it 'should not print command output to STDOUT on UNIX systems if stdout_streaming disabled' do
    if File.exist? '/usr'
      Class.new.extend(Utils).run_os_command('host', 'echo test', false)
      stdout_value = $stdout.string
      expect(stdout_value).to eq ''
    else
      skip('Skipped because OS in not UNIX')
    end
  end
  it 'should print command output to STDERR on UNIX systems if stderr_streaming enabled' do
    #TODO: fix
    # if File.exist? '/usr'
    #   # Class.new.extend(Utils).run_os_command('host', '>&2 echo test')
    #   `>&2 echo test`
    #   stderr_value = $stderr.string
    #   expect(stderr_value).to eq ''
    # else
    #   skip('Skipped because OS in not UNIX')
    # end
  end

end