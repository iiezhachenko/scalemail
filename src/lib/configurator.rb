require_relative 'logger.rb'
require_relative 'verifier.rb'
require 'yaml'
require 'singleton'
require 'erb'
require_relative 'hosts'

module Configurator
  class Config
    include Logger, Verifier, Singleton
    attr_reader :loaded_configuration, :driver, :config_tree, :host_name_prefix
    @@known_drivers = ['amazonec2']
    @@known_host_types = %w(generic swarm-master swarm-node)

    def load_config(config_file_path)
      verify_config_file_availability(config_file_path)

      template = ERB.new File.new(config_file_path).read
      @loaded_configuration = YAML.load template.result(binding)
      @host_name_prefix = @loaded_configuration['options']['host-name-prefix']

      verify_basic_config_structure

      @loaded_configuration['hosts'].each do |host|
        host_name = host.first.to_s
        host_config = get_host_config(host_name)
        host_type = host_config['host-type']

        verify_basic_host_properties(host_name, host_type, host_config)
        validate_amazonec2_options(host_name, host_config)

        @config_tree ||= {}
        hosts_amount = host_config['hosts-amount']
        if hosts_amount > 1
          for i in 1..hosts_amount
            create_host_in_config_tree("#{get_full_host_name(host_name)}-#{i}", host_config, host_type, @driver)
          end
        else
          create_host_in_config_tree("#{get_full_host_name(host_name)}", host_config, host_type, @driver)
        end
      end
    end

    def verify_basic_host_properties(host_name, host_type, host_config)
      abort(build_invalid_config_error("host-type is not defined for host '#{host_name}'")) unless host_type
      abort(build_invalid_config_error("unknown host-type '#{host_type}' for host '#{host_name}'")) \
          unless @@known_host_types.include?(host_type)
      abort(build_invalid_config_error("hosts-amount not defined for host '#{host_name}'")) \
          unless host_config['hosts-amount']

      is_hosts_amount_int = Integer(host_config['hosts-amount']) rescue false
      abort(build_invalid_config_error("hosts-amount must be integer. Host: '#{host_name}'")) \
          unless is_hosts_amount_int

      engine_opts = host_config['engine-opts']
      abort(build_invalid_config_error("engine-opts must be an array in yml notation. Host: '#{host_name}'")) \
          unless engine_opts.nil? || engine_opts.kind_of?(Array)

      commands_to_execute = host_config['commands-to-execute']
      abort(build_invalid_config_error("commands-to-execute must be an array in yml notation. Host: '#{host_name}'")) \
          unless commands_to_execute.nil? || commands_to_execute.kind_of?(Array)

      engine_install_url = host_config['engine-install-url']
      abort(build_invalid_config_error("engine-install-url must be a string. Host: '#{host_name}'")) \
          unless engine_install_url.nil? || engine_install_url.kind_of?(String)

      # Checking 'host' section from Docker Machine config file for 'swarm-node' host type
      if (host_type == 'swarm-node')
        abort(build_invalid_config_error("host-type is swarm-node, but swarm-discovery is not set. Host: '#{host_name}'")) \
          unless host_config['swarm-discovery']
        abort(build_invalid_config_error("swarm-discovery must be a string. Host: '#{host_name}'")) \
          unless host_config['swarm-discovery'].kind_of?(String)
      end
    end

    def verify_basic_config_structure
      @driver = get_option('driver')
      abort(build_wrong_config_format_error('options => driver parameter not found')) unless @driver
      abort(build_invalid_config_error("unknown driver 'aws'")) unless @@known_drivers.include?(@driver)
      abort(build_invalid_config_error("driver set as 'amazonec2', but 'aws-credentials-profile' parameter not set")) \
        unless get_option('aws-credentials-profile')

      # Loading 'hosts' section from Docker Machine config file
      abort(build_invalid_config_error('hosts are not defined')) unless @loaded_configuration['hosts']
    end

    private
    def get_option(key)
      options_hash = @loaded_configuration['options']
      options_hash ? options_hash[key] : nil
    end

    def get_host_config(host_node_name)
      hosts_hash = @loaded_configuration['hosts']
      hosts_hash ? hosts_hash[host_node_name] : nil
    end

    def create_host_in_config_tree(host_name, host_config, host_type, driver)
      case driver
        when 'amazonec2'
          @config_tree[host_name] = Hosts::AmazonHost.new(host_config, host_type)
      end
    end
    def get_full_host_name(name)
      if @host_name_prefix
        return "#@host_name_prefix-#{name}"
      end
    else
      return name
    end
  end
end