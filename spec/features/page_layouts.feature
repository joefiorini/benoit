Feature: Page Layouts

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
      
  @backlog
  Scenario: Loads content from markdown files
    Given a site named "test"
    And a file named "index.html" with content:
    """
    {% for post in site.posts %}
      {{ post.content }}
    {% endfor %}
    """
    And a file named "post.markdown" exists with content:
    """
    ---
    type: post
    ---

    This is the content
    """
    When I run `staticly build`
    Then the output file "index.html" should contain:
    """
    This is the content
    """
