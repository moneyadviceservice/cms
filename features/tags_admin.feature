Feature: Tags administration
  As a content editor
  I want to manage available tags
  So that pages, files, etc can be tagged using them

  @javascript
  Scenario: Accessing tags admin page
    When I visit the tags admin page
    Then I should see a tags header
    And  a tags creation section
    And  also a tags existing section

  @javascript
  Scenario: Creating a valid tag hitting enter
    Given I am on the tags admin page
    When  I introduce a non-existing value in the tags creation box
    Then  The new tag should be persisted after hitting enter

  @javascript
  Scenario: Creating a valid tag hitting comma
    Given I am on the tags admin page
    When  I introduce a non-existing value in the tags creation box
    Then  The new tag should be persisted after hitting ,

  @javascript
  Scenario: Creating an invalid tag
    Given I am on the tags admin page
    When  I introduce an existing value in the tags creation box
    Then  The new tag should not be persisted

  @javascript
  Scenario: Listing existing tags starting by a letter
    Given I am on the tags admin page
    And   There are tags starting by a certain letter
    When  I click on the letter to list the tags starting by it
    Then  The list of existing tags gets displayed

  @javascript
  Scenario: Listing empty list of tags starting by a letter
    Given I am on the tags admin page
    And   No tags starting by a certain letter exist
    When  I click on the letter to list the tags starting by it
    Then  A 'void list' message get displayed
    And   No tags get displayed

  @javascript
  Scenario: Creating a valid tag updates its listing if displayed
    Given I am on the tags admin page
    And   I click on a letter to list the tags starting by it
    When  I create a new tag starting by that letter
    Then  The new tag must appear in the displayed tag listing
