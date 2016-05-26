Feature: As a User I want to get application usage information if not 
  arguments provided, so I know, how to use it.

  Scenario: App just runs
    When I get help for "scalemail"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      |--version|
    And the banner should document that this app takes no arguments
