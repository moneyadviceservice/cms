Feature: Page Categories
  As a content editor
  I want to be able to add an article to an existing category
  so that website visitors can find the content under the relevant section on the site

Scenario: Article belongs to category on the site
  Given I have an article with categories
  When I visit the article's edit page
  Then I should see the article's category

Scenario: User can add an article to an existing category
  Given I have an article without categories
  When I visit the article's edit page
  And I add a category to the article
  Then I should see the article's category

Scenario: User can change article category
  Given I have an article with categories
  When I visit the article's edit page
  And I change the article's category
  Then I should see the article's new category

@javascript
Scenario: Article can be removed from a category
  Given I have an article with categories
  When I visit the article's edit page
  And I remove the article's categories
  Then I see no categories listed on the article's page
