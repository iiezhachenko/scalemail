require_relative 'utils.rb'
require 'open4'
require 'yaml'
require 'singleton'
require_relative 'configurator'

class Provisioner
  include Utils, Logger, Singleton
  attr_reader :hosts

  def provision
    @hosts = {}
    provision_hosts
  end

  def provision_hosts
    threads = []
    @host_name_prefix = Configurator::Config.instance.host_name_prefix
    get_config_tree.each do |host|
      host_name = host[0]
      host_config = host[1]

      host_node_name = host_name.sub(/\-\d?$/, '').sub(/^#@host_name_prefix-/, '')
      host_config_node = get_config['hosts'][host_node_name]
      placeholders = host_config_node['placeholders']
      if placeholders
        placeholders.each do |key, value|
          if key=='host_ip'
            value = "#@host_name_prefix-#{value}" unless @host_name_prefix.nil?
            if @hosts[value] && @hosts[value][:ip]
              replacement = @hosts[value][:ip]
            else
              abort("Cant find IP for host '#{value}' to use in placeholder")
            end
          end
          host_config.creation_string.each do |parameter|
            if parameter.respond_to?(:each)
              parameter.each do |subparam|
                if subparam.respond_to?(:sub!)
                  subparam.sub! "$#{key}$", replacement
                end
              end
            else
              parameter.sub! "$#{key}$", replacement
            end
          end
        end
      end
      print_provisioning_plan host_name
      synchron = get_config['hosts'][host_node_name]['synchronous']
      if synchron == true
        create_host(host_name, host_config).join()
        next
      end
      threads.push(create_host host_name, host_config)
    end
    threads.each { |thread| thread.join }
    puts @hosts.to_s
  end

  def create_host(host_name, host_config)
    host_node_name = host_name.sub(/^#@host_name_prefix-/, '').sub(/\-\d?$/, '')
    host_creation_string = host_config.get_creation_string
    thread = Thread.new do
      process = run_os_command(host_name, "docker-machine create #{host_creation_string} #{host_name}")
      if process[:process].exitstatus != 0
        # abort("#{host_name} creation failed. Check log for details.")
      end
      @hosts[host_name] = {:ip => get_host_ip(host_name)}
      host_cong = get_config['hosts'][host_node_name]
      commands = host_cong['commands-to-execute']
      if commands
        commands.each do |command|
          process = run_os_command(host_name, "docker-machine ssh #{host_name} #{command}")
          if process[:process].exitstatus != 0
            # abort("#{host_name} provisioning failed. Check log for details.")
          end
        end
      end
    end
    thread
  end

  def get_host_ip(host_name)
    while true
      process = run_os_command host_name, "docker-machine ip #{host_name}"
      if process[:process].exitstatus == 0
        ip = process[:stdout][/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/, 0]
        if !ip.nil?
          formatted_log_to_stdout("OUT [#{host_name}]", "Got IP: #{ip}")
          return ip
        end
      else
        formatted_log_to_stdout("OUT [#{host_name}]", 'Waiting 10 seconds for IP.')
        sleep 10
      end
    end
  end

  def print_provisioning_plan(host_name)
    host_config = get_config_tree[host_name]
    formatted_log_to_stdout "PLAN [#{host_name}]", "docker machine create #{host_config.get_creation_string} #{host_name}"
  end

  def get_config
    Configurator::Config.instance.loaded_configuration
  end

  def get_config_tree
    Configurator::Config.instance.config_tree
  end


end