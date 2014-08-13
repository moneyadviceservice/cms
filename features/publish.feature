Feature: Publish
  As a content editor
  I want to be able to publish an article
  so that website visitors can read it

  Scenario: Publish new article
    When I create a new article
    Then I should be able to publish it
