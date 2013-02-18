Feature: Compiling Sass Files

  Background:
    Given a site

  Scenario: Converts SCSS files to CSS
    Given a file named "styles.scss" with content:
    """
    $variable: value;

    .test {
      .nested {
        attribute: $variable;
      }
    }
    """
    When I build the site
    Then the output file "styles.css" should have content:
    """
    .test .nested {
      attribute: value; }
    """

  Scenario: Makes Compass available
    Given a file named "styles.scss" with content:
    """
    @import "compass/css3";
    """
    When I build the site
    Then the output file "styles.css" should exist
