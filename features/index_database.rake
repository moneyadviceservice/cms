Feature: Index Database for Site Search
  As a user
  I want to search through the site
  So I can find the content I am looking for

  Scenario: Index Categories
    Given I have the category
      | Field          | Value                            |
      | label          | budgeting-and-managing-money     |
      | title_en       | Budgeting and managing money     |
      | title_cy       | Cyllidebu a rheoli arian         |
      | description_en | Advice on running a bank account |
      | description_cy | Cyngor ar redeg cyfrif banc      |
    When I run `rake search:index`
    Then the output should contain:
    """
+-------------------------------------------------+------------------------------------------------+
|                                Index: pages - 2 number of indices                                |
+-------------------------------------------------+------------------------------------------------+
| Field                                           | Value                                          |
+-------------------------------------------------+------------------------------------------------+
| objectID                                        | /en/categories/budgeting-and-managing-money    |
| title                                           | Budgeting and managing money                   |
| description                                     | Advice on running a bank account               |
| links                                           | []                                             |
+-------------------------------------------------+------------------------------------------------+
| objectID                                        | /cy/categories/budgeting-and-managing-money    |
| title                                           | Cyllidebu a rheoli arian                       |
| description                                     | Cyngor ar redeg cyfrif banc                    |
| links                                           | []                                             |
+-------------------------------------------------+------------------------------------------------+
    """

  Scenario: Index Pages
    Given I have the page
      | Field            | Value                                                         |
      | label            | Budget planner                                                |
      | page_type        | tool                                                          |
      | slug             | budget-planner                                                |
      | meta_description | Use the free online Money Advice Service Budget Planner tools |
      | content          | some content                                                  |
    When I run `rake search:index`
    Then the output should contain:
    """
+----------------------------------+---------------------------------------------------------------+
|                                Index: pages - 1 number of indices                                |
+----------------------------------+---------------------------------------------------------------+
| Field                            | Value                                                         |
+----------------------------------+---------------------------------------------------------------+
| objectID                         | /en/tools/budget-planner                                      |
| title                            | Budget planner                                                |
| description                      | Use the free online Money Advice Service Budget Planner tools |
| content                          | some content                                                  |
| published_at                     |                                                               |
+----------------------------------+---------------------------------------------------------------+
    """
