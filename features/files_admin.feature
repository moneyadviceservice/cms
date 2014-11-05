Feature: Files administration
  As a content editor
  I want to manage available files
  So that they can be part of the content of pages

  @javascript
  Scenario: Accessing the files admin page
    When I visit the files admin page
    Then I should see a files header
    And  a file filters section
    And  also a file listing section

  @javascript
  Scenario: Sorting the list of files
    Given I am on the files admin page
    When  I choose to sort files by name
    Then  The new tag should be persisted after hitting Enter
