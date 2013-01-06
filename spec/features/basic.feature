Feature: Version Flag

  @backlog
  Scenario: --version flag
    When I run with the "--version" flag
    Then I see the current Staticly version
