Feature: Building News Pages
  As an Editor
  In order to build a News Page
  I want to be able to fill out all the fields on the form

  Background:
    Given I have a news page layout setup with components
    And I am logged in

  Scenario: Creating a news page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "News" on the creation page
    And I create a page "Press release: A new way to pay!"
    When I edit the page "Press release: A new way to pay!"
    And I fill in
      | FIELD            | VALUE                              |
      | hero_image       | /assets/styleguide/hero-sample.jpg |
      | hero_description | Press release: A new way to pay!   |
      | cta_links        | [Test](/test)                      |
    And I enter an order_by date of "29 November 2016"
    And I save and return to the homepage
    And when I click the "Press release: A new way to pay!" page
    Then I should see the fields filled with the content
      | FIELD            | VALUE                              |
      | hero_image       | /assets/styleguide/hero-sample.jpg |
      | hero_description | Press release: A new way to pay!   |
      | cta_links        | [Test](/test)                      |
    And I should see an order_by date of "29 November 2016"
