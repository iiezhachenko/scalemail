module Verifier
  def verify_config_file_availability(config_file_path)
    abort("Docker Machine configuration file not found: #{config_file_path}") unless File.exist?(config_file_path)
    abort("Can't read Docker Machine configuration file: #{config_file_path}") unless File.readable?(config_file_path)
  end

  def validate_amazonec2_options(host_name, host_config)
    abort(build_invalid_config_error("amazonec2-region not defined for host '#{host_name}'")) unless host_config['amazonec2-region']

    amazonec2_region = host_config['amazonec2-region']
    abort(build_invalid_config_error("amazonec2-region must be a string. Host: '#{host_name}'")) \
          unless amazonec2_region.kind_of?(String)

    abort(build_invalid_config_error("amazonec2-zone not defined for host '#{host_name}'")) unless host_config['amazonec2-zone']

    amazonec2_zone = host_config['amazonec2-zone']
    abort(build_invalid_config_error("amazonec2-zone must be a string. Host: '#{host_name}'")) \
          unless amazonec2_zone.kind_of?(String)

    abort(build_invalid_config_error("amazonec2-vpc-id not defined for host '#{host_name}'")) unless host_config['amazonec2-vpc-id']

    amazonec2_vpc_id = host_config['amazonec2-vpc-id']
    abort(build_invalid_config_error("amazonec2-vpc-id must be a string. Host: '#{host_name}'")) \
          unless amazonec2_vpc_id.kind_of?(String)

    abort(build_invalid_config_error("amazonec2-subnet-id not defined for host '#{host_name}'")) unless host_config['amazonec2-subnet-id']

    amazonec2_subnet_id = host_config['amazonec2-subnet-id']
    abort(build_invalid_config_error("amazonec2-subnet-id must be a string. Host: '#{host_name}'")) \
          unless amazonec2_subnet_id.kind_of?(String)

    abort(build_invalid_config_error("amazonec2-security-group not defined for host '#{host_name}'")) unless host_config['amazonec2-security-group']

    amazonec2_security_group = host_config['amazonec2-security-group']
    abort(build_invalid_config_error("amazonec2-security-group must be a string. Host: '#{host_name}'")) \
          unless amazonec2_security_group.kind_of?(String)

    abort(build_invalid_config_error("amazonec2-instance-type not defined for host '#{host_name}'")) unless host_config['amazonec2-instance-type']

    amazonec2_instance_type = host_config['amazonec2-instance-type']
    abort(build_invalid_config_error("amazonec2-instance-type must be a string. Host: '#{host_name}'")) \
          unless amazonec2_instance_type.kind_of?(String)

    amazonec2_ami = host_config['amazonec2-ami']
    abort(build_invalid_config_error("amazonec2-ami must be a string. Host: '#{host_name}'")) \
          unless amazonec2_ami.nil? || amazonec2_ami.kind_of?(String)
  end
end
