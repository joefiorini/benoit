Feature: Version Flag

  Scenario: --version flag
    When I run `staticly --version`
    Then I see the current Staticly version
