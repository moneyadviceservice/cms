Feature: As an Editor
         In order to the build an Insights Page
         I want to be able to fill out all the text fields on the form

  Background:
    Given I have an insight page type

  Scenario: Fill out overview
    Given I am logged in
    And I click create new page
    And I fill in a Title
    And I choose Insight page type
    And I save the draft
    When I fill in overview field
    And I click save

    Then I should see the text I input






    Given I am a normal user
    When I am working on a new unsaved article
    And I see that the state is "Unsaved"
    And I should be on the live content editing page
    And I populate the editor with the text "draft content"
    And I press the button "Save to Draft"
    Then I should see that the state is "Draft"
    And I should be on the live content editing page
    And I should see the text "draft content" in the editor
    And I should see the button "Save Changes to Draft"

    When I populate the editor with the text "content for publishing"
    And I click the caret to show more buttons
    And I press the button "Publish"
    Then I should see that the state is "Published"
    And I should be on the live content editing page
    And I should see the text "content for publishing" in the editor

    When I populate the editor with the text "a tweak to the content"
    And I click the caret to show more buttons
    And I press the button "Update Live Article"
    Then I should see that the state is still "Published"
    And I should be on the live content editing page
    And I should see the text "a tweak to the content" in the editor
