Feature: Page Tags
  As a CMS user editing or creating a page
  I can add multiple tags to it
  So this page can be found using them.

  @javascript
  Scenario: Accessing tagging field box when no tags available
    Given There are no available tags
    When  I visit the new page
    Then  I should not see a tags field to fill in

  @javascript
  Scenario: Accessing tagging field box when tags available
    Given There are available tags
    When  I visit the new page
    Then  I should see a tags field to fill in

  @javascript
  Scenario: Saving a page with no tags
    Given I visit the new page
    When  I associate no tags in the tagging box
    Then  I should be able to save the page

  @javascript
  Scenario: Saving a page with tags
    Given There are available tags
    And   Mirrored sites
    When  I visit the new page
    And   I enter some tags in the tagging box
    Then  I should be able to save the page
    And   The new page gets associated to them
    And   The welsh version too

  @javascript
  Scenario: Accessing tagging field box when tags available
    Given There are available tags
    When  I am editing a page
    Then  I should see a tags field to fill in

  @javascript
  Scenario: Saving a page with no tags
    Given I am editing a page
    When  I associate no tags in the tagging box
    Then  I should be able to save the page changes

  @javascript
  Scenario: Saving a page with tags
    Given There are available tags
    And   Mirrored sites
    When  I am editing a page
    And   I enter some tags in the tagging box
    Then  I should be able to save the page changes
    And   The page get associated to them
    And   The welsh version too
