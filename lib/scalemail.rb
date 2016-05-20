require 'optparse'
require 'ostruct'

# Application entry point
class Scalemail
  attr_reader :options

  def initialize(args)
    @options = OpenStruct.new
    parse_options args
  end

  def parse_options(args)
    args << '-h' if args.empty?
    parser = prepare_parser { |opts| read_dm_cfg_arg opts }
    parser.parse! args
  end

  def prepare_parser
    OptionParser.new do |opts|
      opts = self.class.send(:add_help_header, opts)
      yield opts
      opts.on_tail('-h', '--help', 'Show this message') { abort(opts.to_s) }
    end
  end

  private

  def read_dm_cfg_arg(opts)
    opts.on('-m', '--docker-machine-config FILE',
            'Docker Machine config file to load') \
           { |cfile| @options.docker_machine_config_file = cfile }
  end

  class << self
    protected

    def add_help_header(opts)
      opts.banner = 'Usage: scalemail -m DOCKER_MACHINE_CONFIG_PATH [options]'
      opts.separator ''
      opts.separator 'Specific options:'
      opts
    end
  end
end
