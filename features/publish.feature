Feature: Publish
  As a content editor
  I want to be able to publish an article
  so that website visitors can read it

  Scenario: Can not publish new article
    When I create a new article
    Then I should not be able to publish it

  Scenario: Publish draft article
    When I am working on a Draft Article
    Then I should be able to publish it

  Scenario: External editor cannot publish an article
    Given I am an editor user
    When I am working on a Draft Article
    Then I should not be able to publish the article
