Feature: User Management
  As an Admin user
  I can create user accounts
  so they can access the Comfy CMS

  Scenario: Create new user
    When I visit the user management page
    And I add a new user
    Then the new user should be able to log in

  Scenario: Delete new user
    When I visit the user management page
    And I add a new user
    When I delete the new user
    Then the new user should not be able to log in

  Scenario: Non admin user
    Given I am not an admin user
    Then I should not be able to visit the user management page

  Scenario: Non admin user goes to profile page
    Given I am not an admin user
    When I visit the user management page
    And I go to my profile page
    Then I should be able to see my profile

  Scenario: Editor goes to the user management page
    Given I am an editor user
    Then I should not be able to visit the user management page
