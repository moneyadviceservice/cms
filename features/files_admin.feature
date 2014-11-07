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
  Scenario: Sorting files by name
    Given I am on the files admin page
    When  I choose to sort files by name
    Then  They get ordered by name

  @javascript
  Scenario: Sorting files by date
    Given I am on the files admin page
    When  I choose to sort files by date
    Then  They get ordered by date (lattest first)

  @javascript
  Scenario: Switching files sort fields
    Given I am on the files admin page
    When  I choose to sort files by date
    Then  They get ordered by date (lattest first)
    When  I choose to sort files by name
    Then  They get ordered by name
    When  I choose to sort files by date
    Then  They get ordered by date (lattest first)

  @javascript
  Scenario: Filtering images files
    Given I am on the files admin page
    When  I choose to filter files by jpg type
    Then  Only jpg files are shown

  @javascript
  Scenario: Filtering pdf files
    Given I am on the files admin page
    When  I choose to filter files by pdf type
    Then  Only pdf files are shown

  @javascript
  Scenario: Filtering document files
    Given I am on the files admin page
    When  I choose to filter files by doc type
    Then  Only doc files are shown

  @javascript
  Scenario: Filtering spreadsheets files
    Given I am on the files admin page
    When  I choose to filter files by xls type
    Then  Only xls files are shown

  @javascript
  Scenario: Sorting and Filtering at the same time
    Given I am on the files admin page
    When  I choose to sort files by date
    Then  They get ordered by date (lattest first)
    When  I choose to filter files by jpg type
    Then  Only jpg files sorted by date are shown
    When  I choose to sort files by name
    Then  Only jpg files sorted by name are shown
