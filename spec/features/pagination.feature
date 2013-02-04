Feature: Content Pagination

  Background:
    Given a site

  @wip @announce
  Scenario: Outputs one file per page
    Given a file named "page.html" containing metadata:
    """
    per_page: 10
    """
    And 20 files containing metadata:
    """
    type: post
    """
    When I build the site
    Then the output file "page1.html" should exist
    And the output file "page2.html" should exist
    And the output file "page.html" should not exist
