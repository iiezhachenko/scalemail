def self.generic_attr_catalogue
  [
    { name: 'driver', class: StringAttribute, mandatory: true },
    { name: 'engine-install-url', class: StringAttribute },
    { name: 'engine-opt', class: ArrayAttribute },
    { name: 'engine-insecure-registry', class: ArrayAttribute },
    { name: 'engine-registry-mirror', class: ArrayAttribute },
    { name: 'engine-label', class: ArrayAttribute },
    { name: 'engine-storage-driver', class: StringAttribute },
    { name: 'engine-env', class: StringAttribute }
  ]
end

def self.swarm_attr_catalogue
  [
    { name: 'swarm-image', class: StringAttribute },
    { name: 'swarm-discovery', class: StringAttribute, mandatory: true },
    { name: 'swarm-strategy', class: StringAttribute },
    { name: 'swarm-opt', class: ArrayAttribute },
    { name: 'swarm-host', class: StringAttribute },
    { name: 'swarm-addr', class: StringAttribute },
    { name: 'swarm-experimental', class: BoolAttribute }
  ]
end

def self.amazonec2_attr_catalogue
  [
    { name: 'amazonec2-access-key', class: StringAttribute },
    { name: 'amazonec2-secret-key', class: StringAttribute },
    { name: 'amazonec2-session-token', class: StringAttribute },
    { name: 'amazonec2-ami', class: StringAttribute },
    { name: 'amazonec2-region', class: StringAttribute },
    { name: 'amazonec2-vpc-id', class: StringAttribute, mandatory: true },
    { name: 'amazonec2-zone', class: StringAttribute },
    { name: 'amazonec2-subnet-id', class: StringAttribute, mandatory: true },
    { name: 'amazonec2-security-group', class: StringAttribute, mandatory: true },
    { name: 'amazonec2-tags', class: ArrayAttribute },
    { name: 'amazonec2-instance-type', class: StringAttribute },
    { name: 'amazonec2-device-name', class: StringAttribute },
    { name: 'amazonec2-root-size', class: StringAttribute },
    { name: 'amazonec2-volume-type', class: StringAttribute },
    { name: 'amazonec2-iam-instance-profile', class: StringAttribute },
    { name: 'amazonec2-ssh-user', class: StringAttribute },
    { name: 'amazonec2-request-spot-instance', class: BoolAttribute },
    { name: 'amazonec2-spot-price', class: StringAttribute },
    { name: 'amazonec2-use-private-address', class: BoolAttribute },
    { name: 'amazonec2-private-address-only', class: BoolAttribute },
    { name: 'amazonec2-monitoring', class: BoolAttribute },
    { name: 'amazonec2-use-ebs-optimized-instance', class: BoolAttribute },
    { name: 'amazonec2-ssh-keypath', class: StringAttribute },
    { name: 'amazonec2-retries', class: StringAttribute }
  ]
end
