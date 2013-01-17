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
    When I run `staticly build`
    Then the output file "index.html" should contain:
    """
    <section id="main">
      boo
    </section>
    """

  Scenario: Reads layout from metadata in .html files
    Given a file with an extension of ".html" containing metadata:
    """
    layout: _layout
    """
    And that file has content:
    """
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

  Scenario: Doesn't require layouts prefixed with underscore
    Given a file with an extension of ".html" containing metadata:
    """
    layout: layout
    """
    And that file has content:
    """
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
