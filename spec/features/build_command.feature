Feature: benoit build

  Background:
    Given a site

  Scenario: Defaults output path to "./_build"
    When I build the site
    Then a directory named "_build" should exist

  Scenario: Defaults cache path to "/tmp/.benoit/tmpcache/{site}"
    When I build the site
    Then a cache directory should exist for that site

  Scenario: Successfully processes images
    Given the site has a file that is an image
    When I build the site
    Then the image should exist in the output site

  Scenario: --clean argument cleans before building
    Given a file
    When I build the site
    Then that file should exist in the output site
    When I delete the file
    And I build the site with the flag "--clean"
    Then that file should not exist in the output site

  Scenario: Builds without any content pages
    Given a file with an extension of ".html" with content:
    """
    before
    {% for post in site.posts %}
      blah
    {% endfor %}
    after
    """
    When I build the site
    Then the output file should only have content:
    """
    before

    after
    """

  Scenario: Does not copy any files in .benoitignore
    Given a file named ".benoitignore" with content:
    """
    a.sh
    """
    And a file named "a.sh" with content:
    """
    testing
    """
    When I build the site
    Then the file "a.sh" should not exist in the output site
    And the file ".benoitignore" should not exist in the output site

  @backlog
  Scenario: Override default output path
    When I run `benoit build --output-path _compiled`
    Then an empty directory named "_compiled" should exist

  @backlog
  Scenario: Override default cache path
    When I run `benoit build --cache-path _cache`
    Then an empty directory named "_cache" should exist

  Scenario: Builds a single file
    Given a file named "index.html" with content:
    """
    <h1>Hello World</h1>
    """
    When I run `benoit build`
    Then the output file "index.html" should have content:
    """
    <h1>Hello World</h1>
    """
