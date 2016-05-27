Feature: Show help banner
  As a User
  I want to get application usage information
  So I know, how to use it.

  Scenario: I start application with --help argument
    When I get help for "scalemail"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |-m|
      |--docker-machine-config|
      |-h|
      |--help|
      |--version|
      |--log-level|
    And the banner should document that this app takes no arguments

  Scenario: I provide Docker Machine config file, which cannot be read
    When I run `scalemail --docker-machine-config fakefile`
    Then the exit status should not be 0
    And the output should contain "Can't open Docker Machine configuration file"
