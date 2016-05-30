require 'tempfile'
require 'ostruct'
require_relative '../fixtures'
require_relative '../../lib/scalemail'

describe Scalemail::Config do
  before do
    Scalemail::Host.any_instance.stub(:load_attributes)
  end

  it '#options_hash and #hosts_hash contain values from provided config file' do
    Scalemail::Config.any_instance.stub(:load_hosts_array).and_return([])
    config = read_config PRIMITIVE_CONFIG
    expect(config.options_hash).to eq PRIMITIVE_CONFIG['options']
    expect(config.hosts_hash).to eq PRIMITIVE_CONFIG['hosts']
  end

  it '#hosts returns array of hosts objects' do
    config = read_config PRIMITIVE_CONFIG
    expect(config.hosts.length).to eq 2
    config.hosts.each do |host|
      expect(host.respond_to?(:creation_string)).to eq true
    end
  end

  it '#hosts names contain prefix when it is defined in config' do
    config = read_config PRIMITIVE_CONFIG
    config.hosts.each do |host|
      expect(host.name).to match(/Test-\w?/)
    end
  end

  it '#hosts names does not contain prefix when it is not defined in config' do
    cfg_hash = PRIMITIVE_CONFIG
    cfg_hash['options'].delete 'hosts-name-prefix'
    config = read_config cfg_hash
    config.hosts.each do |host|
      expect(host.name).to match(/^(?!Test-)\w?/)
    end
  end
end

def read_config(config_file_hash)
  config_file = test_config_file_path config_file_hash.to_yaml
  config = Scalemail::Config.new config_file
  config
end

def test_config_file_path(yaml)
  config_file = Tempfile.open('cfg')
  config_file.write yaml
  config_file.close
  config_file
end
