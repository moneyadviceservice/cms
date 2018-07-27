Feature: Building Article Pages
  As an Editor
  In order to the build an Article Page
  I want to be able to fill out all the fields on the form

  Background:
    Given I have an article page layout setup with components
    And I am logged in

  Scenario: Creating an insight page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "Article" on the creation page
    And I create a page "UK Strategy"
    When I edit the page "UK Strategy"
    And I fill in
      | FIELD            | VALUE                              |
      | hero_image       | /assets/styleguide/hero-sample.jpg |
      | hero_description | Uk Strategy                        |
      | cta_links        | [Test](/test)                      |
      | download         | [File](a-file)                     |
      | feedback         | email@moneyadviceservice.org.uk    |
    And I save and return to the homepage
    And when I click the "UK Strategy" page
    Then I should see the fields filled with the content
      | FIELD            | VALUE                              |
      | hero_image       | /assets/styleguide/hero-sample.jpg |
      | hero_description | Uk Strategy                        |
      | cta_links        | [Test](/test)                      |
      | download         | [File](a-file)                     |
      | feedback         | email@moneyadviceservice.org.uk    |
