Feature: Building Insight Pages
  As an Editor
  In order to the build an Insights Page
  I want to be able to fill out all the text fields on the form

  Background:
    Given I have an insight page layout
    And I am logged in

  Scenario: Creating an insight page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "Insight" on the creation page
    And I create a page "Fixing family finances"
    When I edit the page "Fixing family finances"
    And I fill in
      | FIELD               | VALUE               |
      | overview            | this is an overview |
      | countries           | Brazingland         |
      | links_to_research   | http://foo          |
      | contact_details     | call Chuck Norris   |
      | year_of_publication | 1066                |
    And I check
      | FIELD                 | VALUE                |
      | topics                | saving               |
      | topics                | financial_capability |
      | countries_of_delivery | united_kingdom       |
      | countries_of_delivery | usa                  |
      | client_groups         | parents_families     |
      | client_groups         | children             |
      | data_types            | qualitative          |

    And I save and return to the homepage
    And when I click the "Fixing family finances" page
    Then I should see the fields filled with the content
      | FIELD               | VALUE               |
      | overview            | this is an overview |
      | countries           | Brazingland         |
      | links_to_research   | http://foo          |
      | contact_details     | call Chuck Norris   |
      | year_of_publication | 1066                |
    And I should see the checkbox fields with the value
      | FIELD                    | VALUE     |
      | saving                   | checked   |
      | financial_capability     | checked   |
      | financial_education      | unchecked |
      | insurance_and_protection | unchecked |
      | united_kingdom           | checked   |
      | usa                      | checked   |
      | scotland                 | unchecked |
      | scotland                 | unchecked |
      | parents_families         | checked   |
      | children                 | checked   |
      | young_people             | unchecked |
      | qualitative              | checked   |
      | quantitative             | unchecked |
