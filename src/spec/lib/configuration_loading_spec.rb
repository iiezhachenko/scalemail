require 'rspec'
require 'tempfile'

def make_proxy_config_file
  data = YAML.load_file @generic_config
  yield data
  File.open(@tmp_config, 'w') { |f| YAML.dump(data, f) }
end

describe 'Configuration Loading' do

  before(:each) do
    $stdout = StringIO.new
    $stderr = StringIO.new
    @generic_config = File.dirname(__FILE__) + '/../resources/default-config.yml'
    @tmp_config = Tempfile.open('proxy.yml')
  end
  after(:all) do
    $stdout = STDOUT
    $stderr = STDERR
  end

  it 'should fail with error if DockerMachine config file not found' do
    expect { Configurator::Config.instance.load_config('fakefile') }.to raise_error(SystemExit, /Docker Machine configuration file not found: fakefile/)
  end
  it 'should fail with error if DockerMachine config file cannot be read' do
    tmpfile = Tempfile.new('fakefile')
    tmpfile.chmod(000)
    expect { Configurator::Config.instance.load_config(tmpfile.path) }.to raise_error(SystemExit, /Can't read Docker Machine configuration file: #{tmpfile.path}/)
  end
  it 'should fail with error if driver is not defined in options section' do
    make_proxy_config_file {|data| data['options'].delete('driver')}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Wrong Docker Machine config format: options => driver parameter not found./)
  end
  it 'should fail with error if driver is unknown' do
    make_proxy_config_file { |data| data['options']['driver'] = 'aws' }
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Invalid Docker Machine config: unknown driver 'aws'./)
  end
  it 'should fail with error if driver is amazonec2 and aws-credentials-profile is nil' do
    make_proxy_config_file {|data| data['options'].delete('aws-credentials-profile')}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Invalid Docker Machine config: driver set as 'amazonec2', but 'aws-credentials-profile' parameter not set./)
  end
  it 'should fail with error if hosts section is not defined' do
    make_proxy_config_file {|data| data.delete 'hosts'}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Invalid Docker Machine config: hosts are not defined./)
  end
  it 'should fail with error if host-type is not defined in host node' do
    make_proxy_config_file {|data| data['hosts']['host'].delete 'host-type'}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
            /Invalid Docker Machine config: host-type is not defined for host 'host'./)
  end
  it 'should fail with error if host type is unknown' do
    make_proxy_config_file {|data| data['hosts']['host']['host-type'] = 'something'}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
            /Invalid Docker Machine config: unknown host-type 'something' for host 'host'./)
  end
  it 'should fail with error if hosts-amount is not defined in host node' do
    make_proxy_config_file {|data| data['hosts']['host'].delete 'hosts-amount'}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
            /Invalid Docker Machine config: hosts-amount not defined for host 'host'./)
  end
  it 'should fail with error if hosts-amount is not integer' do
    make_proxy_config_file {|data| data['hosts']['host']['hosts-amount'] = 'something'}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
            /Invalid Docker Machine config: hosts-amount must be integer. Host: 'host'./)
  end
  it 'should fail with error if engine-opts is not an array' do
    make_proxy_config_file {|data| data['hosts']['host']['engine-opts'] = 'something'}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Invalid Docker Machine config: engine-opts must be an array in yml notation. Host: 'host'./)
  end
  it 'should fail with error if commands-to-execute is not an array' do
    make_proxy_config_file {|data| data['hosts']['host']['commands-to-execute'] = 'something'}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Invalid Docker Machine config: commands-to-execute must be an array in yml notation. Host: 'host'./)
  end
  it 'should fail with error if engine-install-url is not a string' do
    make_proxy_config_file {|data| data['hosts']['host']['engine-install-url'] = [1, 2]}
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Invalid Docker Machine config: engine-install-url must be a string. Host: 'host'./)
  end
  it 'should fail with error if host-type is "swarm-node" and swarm-discovery is not defined' do
    make_proxy_config_file do |data|
      data['hosts']['host'].delete ('swarm-discovery')
      data['hosts']['host']['host-type'] = 'swarm-node'
    end
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Invalid Docker Machine config: host-type is swarm-node, but swarm-discovery is not set. Host: 'host'./)
  end
  it 'should fail with error if host-type is "swarm-node" and swarm-discovery is not a string' do
    make_proxy_config_file do |data|
      data['hosts']['host']['swarm-discovery'] = [1, 2]
      data['hosts']['host']['host-type'] = 'swarm-node'
    end
    expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
          /Invalid Docker Machine config: swarm-discovery must be a string. Host: 'host'./)
  end

  context "Driver: amazonec2" do
    it 'should fail with error if AWS region not defined' do
      make_proxy_config_file {|data| data['hosts']['host'].delete 'amazonec2-region'}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-region not defined for host 'host'./)
    end
    it 'should fail with error if AWS region is not a string' do
      make_proxy_config_file {|data| data['hosts']['host']['amazonec2-region'] = [1, 2]}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-region must be a string. Host: 'host'./)
    end
    it 'should fail with error if AWS availability zone not defined' do
      make_proxy_config_file {|data| data['hosts']['host'].delete 'amazonec2-zone'}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-zone not defined for host 'host'./)
    end
    it 'should fail with error if AWS availability zone is not a string' do
      make_proxy_config_file {|data| data['hosts']['host']['amazonec2-zone'] = [1, 2]}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-zone must be a string. Host: 'host'./)
    end
    it 'should fail with error if AWS VPC ID not defined' do
      make_proxy_config_file {|data| data['hosts']['host'].delete 'amazonec2-vpc-id'}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-vpc-id not defined for host 'host'./)
    end
    it 'should fail with error if AWS VPC ID is not a string' do
      make_proxy_config_file {|data| data['hosts']['host']['amazonec2-vpc-id'] = [1, 2]}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-vpc-id must be a string. Host: 'host'./)
    end
    it 'should fail with error if AWS Subnet ID not defined' do
      make_proxy_config_file {|data| data['hosts']['host'].delete 'amazonec2-subnet-id'}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-subnet-id not defined for host 'host'./)
    end
    it 'should fail with error if AWS Subnet ID is not a string' do
      make_proxy_config_file {|data| data['hosts']['host']['amazonec2-subnet-id'] = [1, 2]}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-subnet-id must be a string. Host: 'host'./)
    end
    it 'should fail with error if AWS Security Group not defined' do
      make_proxy_config_file {|data| data['hosts']['host'].delete 'amazonec2-security-group'}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-security-group not defined for host 'host'./)
    end
    it 'should fail with error if AWS Security Group is not a string' do
      make_proxy_config_file {|data| data['hosts']['host']['amazonec2-security-group'] = [1, 2]}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-security-group must be a string. Host: 'host'./)
    end
    it 'should fail with error if AWS Instance Type not defined' do
      make_proxy_config_file {|data| data['hosts']['host'].delete 'amazonec2-instance-type'}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-instance-type not defined for host 'host'./)
    end
    it 'should fail with error if AWS Instance Type is not a string' do
      make_proxy_config_file {|data| data['hosts']['host']['amazonec2-instance-type'] = [1, 2]}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-instance-type must be a string. Host: 'host'./)
    end
    it 'should fail with error if AWS AMI is not a string' do
      make_proxy_config_file {|data| data['hosts']['host']['amazonec2-ami'] = [1, 2]}
      expect { Configurator::Config.instance.load_config(@tmp_config) }.to raise_error(SystemExit, \
              /Invalid Docker Machine config: amazonec2-ami must be a string. Host: 'host'./)
    end
  end

  it 'should return proper creation string for amazonec2 generic host type' do
    test_creation_string = "--driver amazonec2 "\
        "--engine-install-url 'http://test.com' --engine-opt='opt1' --engine-opt='opt2' "\
        "--amazonec2-region region --amazonec2-zone zone --amazonec2-vpc-id vpc "\
        "--amazonec2-subnet-id subnet --amazonec2-security-group sg --amazonec2-instance-type it --amazonec2-ami ami"
    Configurator::Config.instance.load_config(@generic_config)
    expect(Configurator::Config.instance.config_tree['host'].get_creation_string).to eq(test_creation_string)
  end
  it 'should return proper creation string for swarm-node host type' do
    test_creation_string = "--driver amazonec2 "\
        "--engine-install-url 'http://test.com' --engine-opt='opt1' --engine-opt='opt2' "\
        "--swarm --swarm-discovery='something' "\
        "--amazonec2-region region --amazonec2-zone zone --amazonec2-vpc-id vpc "\
        "--amazonec2-subnet-id subnet --amazonec2-security-group sg --amazonec2-instance-type it --amazonec2-ami ami"
    make_proxy_config_file do |data|
      data['hosts']['host']['swarm-discovery'] = 'something'
      data['hosts']['host']['host-type'] = 'swarm-node'
    end
    Configurator::Config.instance.load_config(@tmp_config)
    expect(Configurator::Config.instance.config_tree['host'].get_creation_string).to eq(test_creation_string)
  end

  it 'should return proper creation string for swarm-master host type' do
    test_creation_string = "--driver amazonec2 "\
        "--engine-install-url 'http://test.com' --engine-opt='opt1' --engine-opt='opt2' "\
        "--swarm-master --swarm --swarm-discovery='something' "\
        "--amazonec2-region region --amazonec2-zone zone --amazonec2-vpc-id vpc "\
        "--amazonec2-subnet-id subnet --amazonec2-security-group sg --amazonec2-instance-type it --amazonec2-ami ami"
    make_proxy_config_file do |data|
      data['hosts']['host']['swarm-discovery'] = 'something'
      data['hosts']['host']['host-type'] = 'swarm-master'
    end
    Configurator::Config.instance.load_config(@tmp_config)
    expect(Configurator::Config.instance.config_tree['host'].get_creation_string).to eq(test_creation_string)
  end


end