Feature: Page Layouts

  Background:
    Given a site

  Scenario: Finds layouts in _layouts
    Given a site named "test"
    And a file named "index.html" with content:
    """
    {% extends "_layout.html" %}

    {% block content %}boo{% endblock %}
    """
    And a file named "_layouts/_layout.html" with content:
    """
    <section id="main">
      {% block content %}{% endblock %}
    </section>
    """
    When I run `benoit build`
    Then the output file "index.html" should have content:
    """
    <section id="main">
      boo
    </section>
    """

  @backlog
  Scenario: Doesn't require layouts prefixed with underscore
    Given a file with an extension of ".html" with content:
    """
    {% extends "layout.html" %}

    {% block content %}CONTENT{% endblock %}
    """
    And a layout named "_layout" with content:
    """
    !!!
    {% block content %}{% endblock %}
    !!!
    """
    When I build the site
    Then the output file should have content:
    """
    !!!
    CONTENT
    !!!
    """
