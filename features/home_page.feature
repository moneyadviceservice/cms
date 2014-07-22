Feature: Home page
  As a content editor
  I want to be able to access the CMS
  So that I can start working

  Scenario: User sees site listing
    When I visit the home page
    Then I should be in the sites section
