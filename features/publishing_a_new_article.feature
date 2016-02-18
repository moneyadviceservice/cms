@javascript
Feature: Publish
  As a content editor
  I want to be able to publish an article
  so that website visitors can read it

  Scenario: Publishing a new article
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
