Feature: Page Categories
  As a content editor
  I want to see all the page revisions from all authors
  In order to manage all the page activities

  Scenario: Publish Page
    When I am working on a Draft Article
    When I publish the article
    And I should be able to see the last revision status
