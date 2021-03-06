Feature: Page meta data
  As a content editor
  I can setup a Meta Description Tag
  so I can make my content successful within Search Engines

  Scenario: Editing meta decription
    When I create a new article
    And I fill in "description" as the meta_description
    And I save the article page
    Then the article's "meta_description" should be "description"

  Scenario: Editing meta title
    When I create a new article
    And I fill in "description" as the meta_title
    And I save the article page
    Then the article's "meta_title" should be "description"
