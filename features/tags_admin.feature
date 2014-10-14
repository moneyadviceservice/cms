Feature: Tags administration
  As a content editor
  I want to manage available tags
  So that pages, files, etc can be tagged using them

  Scenario: Accessing tags admin page
    When I visit the tags admin page
    Then I should see a tags header
    And  a tags creation section
    And  also a tags listing section

  @javascript
  Scenario: Creating a valid tag
    Given I am on the tags admin page
    And   I introduce a non-existing value in the tags creation box
    Then  The new tag should be persisted

  @javascript
  Scenario: Creating an invalid tag
    Given I am on the tags admin page
    And   I introduce an existing value in the tags creation box
    Then  The new tag should not be persisted

  @javascript
  Scenario: Creating an invalid tag
    Given I am on the tags admin page
    And   I introduce an existing value in the tags creation box
    Then  The new tag should not be persisted

  @javascript
  Scenario: Listing existing tags starting by a letter
    Given I am on the tags admin page
    And   I click on a letter to list the tags starting by it
    Then  The list of existing tags starting by that letter get displayed

  @javascript
  Scenario: Listing empty list of tags starting by a letter
    Given I am on the tags admin page
    And   No tags starting by a letter exist
    And   I click on a letter to list the tags starting by it
    Then  A void list message get displayed

  @javascript
  Scenario: Creating a valid tag when its listing is being displayed
    Given I am on the tags admin page
    And   The list of tags starting by a letter is displayed
    And   I introduce new value starting by that letter in the tags creation box
    Then  The new tag should be persisted
    Then  The new tag should also be added to the displayed listing

  @javascript
  Scenario: Deleting a tag
    Given I am on the tags admin page
    And   The list of tags starting by a letter is displayed
    And   I click on one of those tags
    Then  The tag should be removed from the database
    And   The items tagged with it should lose it
    Then  The tag should be removed from it displayed listing
