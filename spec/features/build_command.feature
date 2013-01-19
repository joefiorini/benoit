Feature: staticly build

  Background:
    Given a site named "test"

  Scenario: Defaults output path to "./_build"
    When I run `staticly build`
    Then a directory named "_build" should exist

  Scenario: Defaults cache path to "~/.staticly/tmpcache/{site}"
    When I run `staticly build`
    Then a directory named "~/.staticly/tmpcache/test" should exist

  Scenario: Successfully processes images
    Given the site has a file that is an image
    When I build the site
    Then the image should exist in the output site

  @backlog
  Scenario: Override default output path
    When I run `staticly build --output-path _compiled`
    Then an empty directory named "_compiled" should exist

  @backlog
  Scenario: Override default cache path
    When I run `staticly build --cache-path _cache`
    Then an empty directory named "_cache" should exist

  Scenario: Builds a single file
    Given a file named "index.html" with content:
    """
    <h1>Hello World</h1>
    """
    When I run `staticly build`
    Then the output file "index.html" should contain:
    """
    <h1>Hello World</h1>
    """
