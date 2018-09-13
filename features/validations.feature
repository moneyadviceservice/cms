@javascript
Feature: Editor validations
  As a content editor
  I want to see an error when saving a page without all the required fields
  so that I can see what fields are missing

Scenario: Creating a page without required fields
  Given I am an editor user
  And I am working on a new unsaved article with required fields
    | Identifier              |
    | text_field              |
    | order_by_date:datetime  |
  And I populate the editor with the text ""
  And I press the button "Save to Draft"
  Then I should see that the state is "Unsaved"
  And I should see the fields marked as required
    | Identifier             |
    | text_field             |
    | order_by_date:datetime |
