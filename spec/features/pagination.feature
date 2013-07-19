@backlog
Feature: Content Pagination

  Background:
    Given a site
    And 20 files containing metadata:
    """
    type: post
    """

  Scenario: Outputs one file per page
    Given a file named "page.html" containing metadata:
    """
    posts_per_page: 10
    """
    When I build the site
    Then the output file "page1.html" should exist
    And the output file "page2.html" should exist

  Scenario: Renders 10 posts per page
    Given a file named "page.html" with content:
    """
    ---
    posts_per_page: 10
    ---

    {% for post in site.paginated_posts | sort: "page_num" %}{{post.content}}
    {% endfor %}
    """
    When I build the site
    Then the output file "page1.html" should only contain the first 10 posts
    And the output file "page2.html" should only contain the last 10 posts

  Scenario: Renders 5 posts per page
    Given a file named "page.html" with content:
    """
    ---
    posts_per_page: 5
    ---

    {% for post in site.paginated_posts | sort: "page_num" %}{{post.content}}
    {% endfor %}
    """
    When I build the site
    Then the output file "page1.html" should only contain the first 5 posts
    And the output file "page4.html" should only contain the last 5 posts

  Scenario: Keeps path to paginated files
    Given a file named "dir/page.html" with content:
    """
    ---
    posts_per_page: 5
    ---

    {% for post in site.paginated_posts | sort: "page_num" %}{{post.content}}
    {% endfor %}
    """
    When I build the site
    Then the output file "dir/page1.html" should exist
