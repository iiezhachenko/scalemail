require_relative '../lib/scalemail'

describe Scalemail do
  before do
    $stdout = StringIO.new
    $stderr = StringIO.new
    @banner = [
      'Usage: scalemail -m DOCKER_MACHINE_CONFIG_PATH [options]',
      '',
      'Specific options:',
      '    -m, --docker-machine-config FILE Docker Machine config file to load',
      "    -h, --help                       Show this message\n"
    ].join("\n")
  end
  after(:all) do
    $stdout = STDOUT
    $stderr = STDERR
  end
  it 'shows help when started without arguments' do
    expect { Scalemail.new([]) }.to raise_error(SystemExit, @banner)
  end
  it 'shows help when started with "-h" argument' do
    expect { Scalemail.new(%w(-h)) }.to raise_error(SystemExit, @banner)
  end
  it 'shows help when started with "--help" argument' do
    expect { Scalemail.new(%w(--help)) }.to raise_error(SystemExit, @banner)
  end
end
