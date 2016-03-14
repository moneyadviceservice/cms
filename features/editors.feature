@javascript
Feature: Publish
  As a user in the editor role
  I can work on draft articles only

  Scenario: External editor can update an unsaved article and save it to draft
    Given I am an editor user
    And I am working on a new unsaved article
    And I see that the state is "Unsaved"
    When I populate the editor with the text "new content"
    And I press the button "Save to Draft"
    Then I should see that the state is "Draft"
    And I should see the text "new content" in the editor
    And I should see the button "Save Changes to Draft"

  Scenario: External editor can update but not publish an new draft article
    Given I am an editor user
    And I am working on a new draft article
    And I see that the state is "Draft"
    When I populate the editor with the text "new content"
    And I press the button "Save Changes to Draft"
    Then I should see that the state is still "Draft"
    And I should see the text "new content" in the editor
    And I should see the button "Save Changes to Draft"
    And I should not see the button "Publish changes"

  Scenario: External editor can update but not publish a draft new version of an article
    Given I am an editor user
    And I am working on a draft new version of an article
    And I see that the state is "Published | Draft"
    When I populate the editor with the text "new content"
    And I press the button "Update Draft New Version"
    Then I should see that the state is still "Published | Draft"
    And I should see the text "new content" in the editor
    And I should see the button "Update Draft New Version"
    And I should not see the button "Publish changes"

  Scenario: External editor can update a scheduled article that has not yet gone live
    Given I am an editor user
    And I am working on a scheduled but not live article
    And I see that the state is "Scheduled"
    When I populate the editor with the text "new content"
    And I press the button "Save Changes to Scheduled Article"
    Then I see that the state is still "Scheduled"
    And I should see the text "new content" in the editor
    And I should see the button "Save Changes to Scheduled Article"

  Scenario: External editor cannot update a scheduled article that has gone live
    Given I am an editor user
    And I am working on a scheduled and live article
    And I see that the state is "Published"
    When I populate the editor with the text "new content"
    And I press the button "Update Live Article"
    Then I should the flash message "Insufficient permissions to change"

  Scenario: External editor can update a scheduled update to a live article
    Given I am an editor user
    And I am working on a scheduled update to an article
    And I see that the state is "Published | Scheduled"
    When I populate the editor with the text "new content"
    And I press the button "Save Changes to Scheduled Update"
    Then I see that the state is still "Published | Scheduled"
    And I should see the text "new content" in the editor
    And I should see the button "Save Changes to Scheduled Update"

  Scenario: External editor cannot update a scheduled update to an article that has gone live
    Given I am an editor user
    And I am working on a live scheduled update to an article
    And I see that the state is "Published"
    When I populate the editor with the text "new content"
    And I press the button "Update Live Article"
    Then I should the flash message "Insufficient permissions to change"
