Feature: Building Thematic Reviews Landing Page
  As an Editor
  In order to the build a Thematic Reviews Landing Page
  I want to be able to fill out all the fields on the form

  Background:
    Given I have an thematic reviews landing page layout setup with components
    And I am logged in

  Scenario: Creating a Thematic Reviews Landing Page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "Thematic Reviews Landing Page" on the creation page
    And I create a page "Thematic Reviews Landing Page"
    When I edit the page "Thematic Reviews Landing Page"
    And I fill in
      | FIELD         | VALUE                                               |
      | content       | Thematic Reviews are short overviews of key findings|
    And I save and return to the homepage
    And when I click the "Thematic Reviews Landing Page" page
    Then I should see the fields filled with the content
      | FIELD         | VALUE                                               |
      | content       | Thematic Reviews are short overviews of key findings|
