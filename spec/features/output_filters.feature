Feature: format_like Output Filter

  Background:
    Given a site

  Scenario: Formats simple dates according to passed example
    Given a file with an extension of ".html" with content:
    """
    {{"2012-12-23"|format_like:"March 23, 2012"}}
    """
    When I build the site
    Then the output file should have content:
    """
    December 23, 2012
    """
