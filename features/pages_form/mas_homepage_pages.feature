Feature: Building Homepage Pages
  As an Editor
  In order to the build a MAS homepage
  I want to be able to fill out all the fields on the form

  Background:
    Given I have a home page layout setup with components
    And I am logged in

  Scenario: Creating an 'Home Page' page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "Home Page" on the creation page
    And I create a page "The Money Advice Service"
    When I edit the page "The Money Advice Service"
    And I fill in
      | FIELD             | VALUE                              |
      | raw_hero_image    | /assets/styleguide/hero-sample.jpg |
      | raw_heading       | Money Advice                       |
      | raw_tool_1_heading| pensions calculator                |
      | raw_tool_1_url    | /en/tools/pensions                 |
    And I save and return to the homepage
    And when I click the "The Money Advice Service" page
    Then I should see the fields filled with the content
      | FIELD             | VALUE                              |
      | raw_hero_image    | /assets/styleguide/hero-sample.jpg |
      | raw_heading       | Money Advice                       |
      | raw_tool_1_heading| pensions calculator                |
      | raw_tool_1_url    | /en/tools/pensions                 |
