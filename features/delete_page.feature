Feature: Page Delete
  As a user
  I want to be able to delete an article
  So that I can remove content I no longer want website visitors to see

  Scenario: User or Admin user can delete a page
    When I am working on a Draft Article
    Then I should be able to delete the article

  Scenario: Editor cannot delete a page
    Given I am an editor user
    When I am working on a Draft Article
    Then I should not be able to delete the article
