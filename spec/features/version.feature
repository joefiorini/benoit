Feature: Version Flag

  Scenario: --version flag
    When I run `benoit --version`
    Then I see the current Benoit version
