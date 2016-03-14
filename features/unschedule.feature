@javascript
Feature: Page Delete
  As a user
  I want to be able to delete unwanted drafts
  So that I can stop them accumulating

  Scenario: User or Admin user can unschedule a scheduled article
    Given I am a normal user
    And I am working on a new unsaved article
    When I populate the editor with the text "draft content"
    And I press the button "Save to Draft"
    Then I should see that the state is "Draft"

    When I populate the editor with the text "a scheduled article"
    And I click the caret to show more buttons
    And I press the button "Schedule"
    Then I should see the schedule dialogue

    When I set the schedule time to a time in the future
    And I press the button "Save"
    Then I should see that the state is "Scheduled"

    When I press the button "Unschedule"
    Then I should see that the state is "Draft"

  Scenario: User or Admin user can unschedule an update to a published article
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
    Then I should see that the state is "Published | Draft"

    When I populate the editor with the text "a new version for scheduling for the future"
    And I click the caret to show more buttons
    And I press the button "Schedule"
    Then I should see the schedule dialogue

    When I set the schedule time to a time in the future
    And I press the button "Save"
    Then I should see that the state is "Scheduled"

    # Needed because of the wider button which doesn't
    # display properly on a smaller window.
    When I increase the size of my browser window
    And I press the button "Unschedule"
    Then I should see that the state is "Published | Draft"
