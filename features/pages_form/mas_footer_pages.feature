Feature: Building Footer Pages
  As an Editor
  In order to the build a MAS Footer
  I want to be able to fill out all the fields on the form

  Background:
    Given I have a footer layout setup with components
    And I am logged in

  Scenario: Creating a 'Footer' page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "Footer" on the creation page
    And I create a page "Footer"
    When I edit the page "Footer"
    And I fill in
      | FIELD                | VALUE     |
      | raw_web_chat_heading | web chat  |
      | raw_contact_heading  | email me  |
    And I save and return to the homepage
    And when I click the "Footer" page
    Then I should see the fields filled with the content
      | FIELD             | VALUE        |
      | raw_web_chat_heading | web chat  |
      | raw_contact_heading  | email me  |
