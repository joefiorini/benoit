Feature: Site Context

  Scenario: Groups posts by type
    Given a site named "subpages"
    And a file named "index.html" with content:
    """
    {% for post in site.posts | sort: "date" | reverse | limit: 5 %}
      <a href="{{ post.permalink }}">{{ post.title }}</a>
    {% endfor %}
    """
    And a file named "entries/post.markdown" with content:
    """
    ---
    layout: _post
    type: post
    title: Testing Post
    ---

    This is a test
    """
    And an empty file named "_layouts/_post.html"
    When I run `staticly build`
    Then the output file "index.html" should contain:
    """
    <a href="/entries/post.html">Testing Post</a>
    """

  @backlog
  Scenario: Group arbitrary page types by type


  Scenario: Loads content from markdown files
    Given a site named "test"
    And a file named "index.html" with content:
    """
    {% for post in site.posts %}
      {{ post.content }}
    {% endfor %}
    """
    And a file named "entries/post.markdown" with content:
    """
    ---
    layout: _post
    type: post
    ---

    This is the content
    """
    And an empty file named "_layouts/_post.html"
    When I run `staticly build`
    Then the output file "index.html" should contain:
    """
    This is the content
    """