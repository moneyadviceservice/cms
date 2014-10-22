Feature: User Management
  As an Admin user
  I can create user accounts
  so they can access the Comfy CMS

  Scenario: Create new user
    When I visit the user management page
    And I add a new user
    Then the new user should be able to log in
