require 'optparse'
require 'ostruct'
require_relative 'configurator'
require_relative 'provisioner'

class Scalemail
  attr_reader :options

  def initialize(args)
    process_cli_options(args)
    Configurator::Config.instance.load_config(@options.docker_machine_config_file)
    Provisioner.instance.provision
  end

  def process_cli_options(args)
    @options = OpenStruct.new
    opt_parser = OptionParser.new do |opts|
      opts.banner = 'Usage: scalemail -m DOCKER_MACHINE_CONFIG_PATH [options]'
      opts.separator ''
      opts.separator 'Specific options:'

      if args.empty?
        args << '-h'
      end

      opts.on('-m', '--docker-machine-config FILE', 'Docker Machine config file to load') { |cfile| @options.docker_machine_config_file = cfile }

      opts.on_tail('-h', '--help', 'Show this message') do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
  end

  def configure(config_file)
    Configurator::Config.instance.load_config(config_file)
    configuration
  end

end