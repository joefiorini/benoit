Feature: staticly build

  Background:
    Given a site named "test"

  Scenario: Defaults output path to "./_build"
    When I run `staticly build`
    Then a directory named "_build" should exist

  Scenario: Defaults cache path to "./tmp"
    When I run `staticly build`
    Then a directory named "tmp" should exist

  @backlog
  Scenario: Override default output path
    When I run `staticly build --output-path _compiled`
    Then an empty directory named "_compiled" should exist

  @backlog
  Scenario: Override default cache path
    When I run `staticly build --cache-path _cache`
    Then an empty directory named "_cache" should exist

  @backlog
  Scenario: Builds a single file
    Given an input file named "index.html" with content:
    """
    <h1>Hello World</h1>
    """
    When I run `staticly build`
    Then an output file named "index.html" should exist with content:
    """
    <h1>Hello World</h1>
    """
