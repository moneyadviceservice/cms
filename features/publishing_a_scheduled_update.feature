@javascript
Feature: Publishing an article then scheduling an update
  As a content editor
  I want to be able to publish an article
  so that website visitors can read it

  Scenario: Publishing an article then scheduling an update
    Given I am a normal user
    When I am working on a new unsaved article
    And I see that the state is "Unsaved"
    And I populate the editor with the text "draft content"
    And I press the button "Save to Draft"
    Then I should see that the state is "Draft"
    And I should see the text "draft content" in the editor
    And I should see the button "Save Changes to Draft"

    When I populate the editor with the text "content for publishing"
    And I click the caret to show more buttons
    And I press the button "Publish"
    Then I should see that the state is "Published"
    And I should be on the live content editing page
    And I should see the text "content for publishing" in the editor

    When I populate the editor with the text "a new draft"
    And I click the caret to show more buttons
    And I press the button "Create New Draft Version"
    Then I should see that the state is "Draft"
    And I should be on the alternate content editing page
    And I should see the text "a new draft" in the editor

    When I populate the editor with the text "a new version for scheduling for the future"
    And I click the caret to show more buttons
    And I press the button "Schedule"
    Then I should see the schedule dialogue

    When I set the schedule time to a time in the future
    And I press the button "Save"
    Then I should see that the state is "Scheduled"
    And I should be on the alternate content editing page
    And I should see the text "a new version for scheduling for the future" in the editor
