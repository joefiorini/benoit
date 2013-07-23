Feature: Markdown Files

  Benoit converts Markdown files to HTML (Markdown files are those that end in ".markdown", ".md", ".mkdown" or ".mdown"). It uses the RedCarpet engine for rendering Markdown. Currently, there is no way to configure Markdown settings ([want this? Let me know!][feedback])

  If you use a layout for your site, you can use the regular {% extends ... %} tag and {% block ... %} tags just like you do in HTML files. If you need to use more template features than just the layouts, then you will need to use HTML rather than Markdown.

  Scenario: Converts Markdown to HTML
    Given a file named "cadenza.markdown" with content:
    """
    [blah](http://www.google.com)
    """
    When I build the site
    Then the output file "cadenza.html" should only have content:
    """
    <p><a href="http://www.google.com">blah</a></p>

    """

  Scenario: Properly wraps Markdown files in specified layout
    Given a file named "cadenza.markdown" with content:
    """
    {% extends "_layout.html" %}
    {% block content %}
    [this is my content](http://www.google.com)
    {% endblock %}
    """
    And a file named "_layouts/_layout.html" with content:
    """
    <section id="main">
    {% block content %}{% endblock %}
    </section>
    """
    When I run `benoit build`
    Then the output file "cadenza.html" should have content:
    """
    <section id="main">

    <a href="http://www.google.com">this is my content</a>

    </section>
    """
