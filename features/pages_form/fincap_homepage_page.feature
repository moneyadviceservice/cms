Feature: Building Homepage Page
  As an Editor
  In order to the build a Homepage Page
  I want to be able to fill out all the fields on the form

  Background:
    Given I have a homepage page layout setup with components
    And I am logged in

  Scenario: Creating a Homepage Page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "Homepage" on the creation page
    And I create a page "Homepage Page"
    When I edit the page "Homepage Page"
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
      | horizontal_teaser_title   | Horizontal teaser title                       |
      | horizontal_teaser_image   | /assets/styleguide/hero-sample.jpg            |
      | horizontal_teaser_text    | Officiem im volest pratur, antetum quos laure |
      | horizontal_teaser_link    | [Teaser link](/path-to-link)                  |
      | download                  | [File](a-file)                                |
    And I save and return to the homepage
    And when I click the "Homepage Page" page
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
      | horizontal_teaser_title   | Horizontal teaser title                       |
      | horizontal_teaser_image   | /assets/styleguide/hero-sample.jpg            |
      | horizontal_teaser_text    | Officiem im volest pratur, antetum quos laure |
      | horizontal_teaser_link    | [Teaser link](/path-to-link)                  |
      | download                  | [File](a-file)                                |
