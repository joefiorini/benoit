Feature: Content Pagination

  Background:
    Given a site

  Scenario: Outputs one file per page
    Given a file named "page.html" containing metadata:
    """
    posts_per_page: 10
    """
    And 20 files containing metadata:
    """
    type: post
    """
    When I build the site
    Then the output file "page1.html" should exist
    And the output file "page2.html" should exist
