Feature: Publish
  As a content editor
  I want to be able to publish an article
  so that website visitors can read it

  Scenario: Can not publish new article
    When I create a new article
    Then I should not be able to publish it

  Scenario: Publish draft article
    When I am working on an draft article
    Then I should be able to publish it
