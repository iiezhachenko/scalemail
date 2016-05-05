require_relative 'configurator'
module Hosts
  class BasicHost
    attr_reader :creation_string
    # , :engine_insecure_registries, \
    # :engine_registy_mirrors, :engine_labels, :engine_storage_driver, :engine_env_vars

    def initialize(config, host_type)
      @creation_string ||= []
      engine_install_url = config['engine-install-url']
      engine_opts = config['engine-opts']

      @creation_string.push("--engine-install-url '#{engine_install_url}'") if engine_install_url
      if engine_opts
        engine_opts.each {|opt| @creation_string.push("--engine-opt='"+opt+"'")}
      end

      add_swarm_node_fields config, host_type if host_type=='swarm-node' || host_type=='swarm-master'
    end

    def add_swarm_node_fields(config, host_type)
      swarm_discovery = config['swarm-discovery']
      @creation_string.push('--swarm') if host_type=='swarm-node'
      @creation_string.push('--swarm-master --swarm') if host_type=='swarm-master'
      @creation_string.push("--swarm-discovery='#{swarm_discovery}'")
    end

    def get_creation_string
      @creation_string.join(' ')
    end
  end

  class AmazonHost < BasicHost
    def initialize(config, host_type)
      super(config, host_type)
      @creation_string.unshift('--driver amazonec2')
      @creation_string.push("--amazonec2-region #{config['amazonec2-region']}")
      @creation_string.push("--amazonec2-zone #{config['amazonec2-zone']}")
      @creation_string.push("--amazonec2-vpc-id #{config['amazonec2-vpc-id']}")
      @creation_string.push("--amazonec2-subnet-id #{config['amazonec2-subnet-id']}")
      @creation_string.push("--amazonec2-security-group #{config['amazonec2-security-group']}")
      @creation_string.push("--amazonec2-instance-type #{config['amazonec2-instance-type']}")
      @creation_string.push("--amazonec2-ami #{config['amazonec2-ami']}") if config['amazonec2-ami']
    end
  end

end

