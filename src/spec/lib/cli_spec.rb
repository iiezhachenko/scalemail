require 'rspec'

describe 'CLI Interaction' do
  before do
    $stdout = StringIO.new
    $stderr = StringIO.new
    @banner_message = "Usage: scalemail -m DOCKER_MACHINE_CONFIG_PATH [options]\n"\
                     "\n"\
                     "Specific options:\n"\
                     "    -m, --docker-machine-config FILE Docker Machine config file to load\n"\
                     "    -h, --help                       Show this message\n"
  end
  after(:all) do
    $stdout = STDOUT
    $stderr = STDERR
  end

    it 'should show usage banner if -h option used' do
      expect {Scalemail.new(%w(-h))}.to raise_error(SystemExit)
      out = $stdout.string
      expect(out).to eq(@banner_message)
    end
    it 'should show usage banner if --help option used' do
      expect {Scalemail.new(%w(--help))}.to raise_error(SystemExit)
      out = $stdout.string
      expect(out).to eq(@banner_message)
    end
    it 'should show usage banner if no options provided' do
      expect {Scalemail.new([])}.to raise_error(SystemExit)
      out = $stdout.string
      expect(out).to eq(@banner_message)
    end
    it 'should fail with error if DockerMachine config file not specified' do
      #TODO
    end
    it 'should fail with error if DockerCompose file not specified' do
      #TODO
    end
end