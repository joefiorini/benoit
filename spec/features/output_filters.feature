Feature: format_like Output Filter

  Background:
    Given a site

  Scenario: Formats simple dates according to passed example
    Given a file containing metadata:
    """
    date: 2012-12-23
    type: post
    """
    And that file has content:
    """
    {{page.date|format_like:"March 23, 2012"}}
    """
    When I build the site
    Then the output file should have content:
    """
    December 23, 2012
    """
