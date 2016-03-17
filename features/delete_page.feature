@javascript
Feature: Page Delete
  As a user
  I want to be able to delete unwanted drafts
  So that I can stop them accumulating

  Scenario: User or Admin user can delete a draft page
    Given I am a normal user
    When I am working on a new unsaved article
    And I see that the state is "Unsaved"
    And I populate the editor with the text "draft content"
    And I press the button "Save to Draft"
    Then I should see that the state is "Draft"
    And I should see the text "draft content" in the editor

    When I click the caret to show more buttons
    And I press the button "Delete"
    Then I should see the deletion dialogue

    When I press the button "Yes, delete this"
    Then I should see be redirected back to the page index
    And I should see the latest article in the list

  Scenario: User or Admin user can delete a draft new version of a published article
    Given I am a normal user
    And I am working on a new unsaved article
    When I populate the editor with the text "draft content"
    And I press the button "Save to Draft"
    Then I should see that the state is "Draft"

    When I populate the editor with the text "content for publishing"
    And I click the caret to show more buttons
    And I press the button "Publish"
    Then I should see that the state is "Published"

    When I populate the editor with the text "a new draft"
    And I click the caret to show more buttons
    And I press the button "Create New Draft Version"
    Then I should see that the state is "Draft"

    When I click the caret to show more buttons
    And I press the button "Remove"
    Then I should see the removal dialogue

    When I press the button "Yes, remove this"
    Then I should see be redirected back to the page index
    And I should not see a link to update the draft new version
