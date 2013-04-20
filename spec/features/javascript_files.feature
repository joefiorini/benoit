Feature: Javascript Files

  Background:
    Given a site

  Scenario: Concatenates multiple scripts
    Given a file named "js/a.js" with content:
    """
    var blah = "diddy";
    """
    And a file named "js/b.js" with content:
    """
    var doo = "dah";
    """
    When I build the site
    Then the output file "js/app.js" should exist
    And the output file "js/app.js" should only have content:
    """
    var blah = "diddy";var doo = "dah";
    """
    And "a.js" should not exist in the output site
    And "b.js" should not exist in the output site

  Scenario: Parses Handlebars templates into js/templates.js
    Given a file named "js/templates/blah.handlebars" with content:
    """
    {{ blah }}
    """
    And an empty file named "js/a.js"
    When I build the site
    Then the output file "js/templates.js" should have content:
    """
    Ember.TEMPLATES['blah']=Ember.Handlebars.compile("{{ blah }}")
    """
    And "js/templates/blah.handlebars" should not exist in the output site
