Feature: Building Latest News Page
  As an Editor
  In order to the build a Latest News Page
  I want to be able to fill out all the fields on the form

  Background:
    Given I have a latest news page layout setup with components
    And I am logged in

  Scenario: Creating a Latest News Page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "Latest News" on the creation page
    And I create a page "Latest News Page"
    When I edit the page "Latest News Page"
    And I fill in
      | FIELD            | VALUE                                   |
      | content          | Here you will find all the latest news. |
      | hero_image       | /assets/styleguide/hero-sample.jpg      |
      | hero_description | Latest news                             |
      | cta_links        | [Test](/test)                           |
      | download         | [File](a-file)                          |
      | feedback         | email@moneyadviceservice.org.uk         |
    And I save and return to the homepage
    And when I click the "Latest News Page" page
    Then I should see the fields filled with the content
      | FIELD            | VALUE                                   |
      | content          | Here you will find all the latest news. |
      | hero_image       | /assets/styleguide/hero-sample.jpg      |
      | hero_description | Latest news                             |
      | cta_links        | [Test](/test)                           |
      | download         | [File](a-file)                          |
      | feedback         | email@moneyadviceservice.org.uk         |    
