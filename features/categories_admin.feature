Feature: Categories
  As a content editor
  I want to be able to change the parent category of an existing category
  so that website visitors can find the content under the relevant section on the site

@categories_admin
Scenario: Cannot make a category the parent of itself
  When I visit the categories admin page
  And I select a category
  Then I should not be able to select that category as the parent category
