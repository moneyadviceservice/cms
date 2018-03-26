Feature: Index Database for Site Search
  As an user
  I want search through the site
  So I can find the content I am looking for

  Scenario: Index Categories
    Given I have the category
      | Field          | Value                            |
      | label          | budgeting-and-managing-money     |
      | title_en       | Budgeting and managing money     |
      | title_cy       | Cyllidebu a rheoli arian         |
      | description_en | Advice on running a bank account |
      | description_cy | Cyngor ar redeg cyfrif banc      |
    When I run `INDEXERS_ADAPTER=local rake search:index`
    Then the output should contain:
    """
      Test
    """

  Scenario: Index Pages
