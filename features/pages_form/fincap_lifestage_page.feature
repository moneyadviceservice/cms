Feature: Building Lifestage Page
  As an Editor
  In order to the build a Lifestage Page
  I want to be able to fill out all the fields on the form

  Background:
    Given I have a lifestage page layout setup with components
    And I am logged in

  Scenario: Creating a Lifestage Page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "Lifestage" on the creation page
    And I create a page "Lifestage Page"
    When I edit the page "Lifestage Page"
    And I fill in
      | FIELD                     | VALUE                                         |
      | content                   | Out of compulsory education or other statutory|
      | hero_image                | /assets/styleguide/hero-sample.jpg            |
      | hero_description          | By 2025 we aim to equip all young adults with |
      | teaser_section_title      | Financial capability in action                |
      | teaser1_title             | Ipsem lorem                                   |
      | teaser1_image             | /assets/styleguide/hero-sample.jpg            |
      | teaser1_text              | Lots of text about something                  |
      | teaser1_link              | [Test1](/test1)                               |
      | teaser2_title             | Hic haec hoc                                  |
      | teaser2_image             | /assets/styleguide/hero-sample.jpg            |
      | teaser2_text              | Another scintillating teaser box              |
      | teaser2_link              | [Test2](/test2)                               |
      | teaser3_title             | To be or not to be                            |
      | teaser3_image             | /assets/styleguide/hero-sample.jpg            |
      | teaser3_text              | Officiem im volest pratur, antetum quos laure |
      | teaser3_link              | [Test3](/test3)                               |
      | strategy_title            | Strategy extract                              |
      | strategy_overview         | Adult financial capability is a direct result |
      | strategy_link             | [Test4](/test4)                               |
      | steering_group_list_title | Steering group                                |
      | steering_group_links      | [Test5](/test5)                               |
      | download                  | [File](a-file)                                |
    And I save and return to the homepage
    And when I click the "Lifestage Page" page
    Then I should see the fields filled with the content
      | FIELD                     | VALUE                                         |
      | content                   | Out of compulsory education or other statutory|
      | hero_image                | /assets/styleguide/hero-sample.jpg            |
      | hero_description          | By 2025 we aim to equip all young adults with |
      | teaser_section_title      | Financial capability in action                |
      | teaser1_title             | Ipsem lorem                                   |
      | teaser1_image             | /assets/styleguide/hero-sample.jpg            |
      | teaser1_text              | Lots of text about something                  |
      | teaser1_link              | [Test1](/test1)                               |
      | teaser2_title             | Hic haec hoc                                  |
      | teaser2_image             | /assets/styleguide/hero-sample.jpg            |
      | teaser2_text              | Another scintillating teaser box              |
      | teaser2_link              | [Test2](/test2)                               |
      | teaser3_title             | To be or not to be                            |
      | teaser3_image             | /assets/styleguide/hero-sample.jpg            |
      | teaser3_text              | Officiem im volest pratur, antetum quos laure |
      | teaser3_link              | [Test3](/test3)                               |
      | strategy_title            | Strategy extract                              |
      | strategy_overview         | Adult financial capability is a direct result |
      | strategy_link             | [Test4](/test4)                               |
      | steering_group_list_title | Steering group                                |
      | steering_group_links      | [Test5](/test5)                               |
      | download                  | [File](a-file)                                |
