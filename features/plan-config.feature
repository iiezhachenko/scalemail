Feature: Show Docker Machine commands
  As a User
  I want to get list of Docker Machine commands derrived from provided config
  So I know, what commands will be executed.

  Scenario: I start application and provide valid config file
    When I start application "plan" command  with "examples/docker-machine-config.yml" config
    Then the exit status should be 0
    And the output should contain:
    """
    Docker Commands to be executed:
        docker-machine create --driver amazonec2 --amazonec2-region test-region --amazonec2-zone test-zone --amazonec2-vpc-id test-vpc --amazonec2-subnet-id test-subnet --amazonec2-security-group test-security-group --amazonec2-instance-type test-instance-type --amazonec2-private-address-only --amazonec2-ami test-ami Test-Consul
        docker-machine create --driver amazonec2 --amazonec2-region test-region --amazonec2-zone test-zone --amazonec2-vpc-id test-vpc --amazonec2-subnet-id test-subnet --amazonec2-security-group test-security-group --amazonec2-instance-type test-instance-type --swarm --swarm-master --swarm-discovery="consul://test-consul:8500" --engine-opt="cluster-store=consul://test-consul:8500" --engine-opt="cluster-advertise=eth0:2376" --amazonec2-private-address-only --amazonec2-ami test-ami Test-Swarm-Master
        docker-machine create --driver amazonec2 --amazonec2-region test-region --amazonec2-zone test-zone --amazonec2-vpc-id test-vpc --amazonec2-subnet-id test-subnet --amazonec2-security-group test-security-group --amazonec2-instance-type test-instance-type --swarm --swarm-discovery="consul://test-consul:8500" --engine-opt="cluster-store=consul://test-consul:8500" --engine-opt="cluster-advertise=eth0:2376" --amazonec2-private-address-only --amazonec2-ami test-ami Test-Swarm-Node-1
        docker-machine create --driver amazonec2 --amazonec2-region test-region --amazonec2-zone test-zone --amazonec2-vpc-id test-vpc --amazonec2-subnet-id test-subnet --amazonec2-security-group test-security-group --amazonec2-instance-type test-instance-type --swarm --swarm-discovery="consul://test-consul:8500" --engine-opt="cluster-store=consul://test-consul:8500" --engine-opt="cluster-advertise=eth0:2376" --amazonec2-private-address-only --amazonec2-ami test-ami Test-Swarm-Node-2
    """
