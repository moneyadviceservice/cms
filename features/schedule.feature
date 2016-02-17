Feature: Page schedule
  As a user
  I want to be able to schedule an article
  So that I can publish content at a specific time or date

  Scenario: Admin can schedule an page
    Given I am an admin user
    When I am working on a new draft article
    Then I should be able to schedule the article

  Scenario: Editor cannot schedule a page
    Given I am an editor user
    When I am working on a new draft article
    Then I should not be able to schedule the article
