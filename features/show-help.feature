Feature: Show help banner
  As a User
  I want to get application usage information
  So I know, how to use it.

  Scenario: I start application with --help option
    When I get help for "scalemail"
    Then the exit status should be 0
    And the output should contain:
    """
    NAME
        scalemail - Application scaling toolkit

    SYNOPSIS
        scalemail [global options] command [command options] [arguments...]

    VERSION
        0.0.1

    GLOBAL OPTIONS
        --help                           - Show this message
        -m, --docker-machine-config=FILE - YAML file with Docker Machine hosts
                                           description (default:
                                           ./docker-machine-config.yml)
        --version                        - Display the program version

    COMMANDS
        help - Shows a list of commands or help for one command
        plan - Print Docker Machine commands to be executed

    """
