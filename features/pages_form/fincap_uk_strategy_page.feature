Feature: Building UK Strategy Page
  As an Editor
  In order to the build a UK Strategy Page
  I want to be able to fill out all the fields on the form

  Background:
    Given I have a uk strategy page layout setup with components
    And I am logged in

  Scenario: Creating a UK Strategy Page
    Given I am on the homepage
    And I click on "Create new page"
    And I select "UK Strategy" on the creation page
    And I create a page "UK Strategy Page"
    When I edit the page "UK Strategy Page"
    And I fill in
      | FIELD                     | VALUE                              |
      | content                   | Test content                       |
      | hero_image                | /assets/styleguide/hero-sample.jpg |
      | hero_description          | Test description                   |
      | teaser_section_title      | Test section title                 |
      | teaser1_title             | Test teaser title 1                |
      | teaser1_image             | /assets/styleguide/hero-sample.jpg |
      | teaser1_text              | Test text                          |
      | teaser1_link              | [Test1](/test1)                    |
      | teaser2_title             | Test tesaer title 2                |
      | teaser2_image             | /assets/styleguide/hero-sample.jpg |
      | teaser2_text              | Test teser text 2                  |
      | teaser2_link              | [Test2](/test2)                    |
      | teaser3_title             | Test teaser title 3                |
      | teaser3_image             | /assets/styleguide/hero-sample.jpg |
      | teaser3_text              | Test teaser text 3                 |
      | teaser3_link              | [Test3](/test3)                    |
      | regional_strategy_title   | Test regional strategy title       |
      | regional_strategy_text    | Test regional strategy text        |
      | regional_strategy_link    | /test-regional-strategy.link       |
      | download                  | [File](a-file)                     |
    And I save and return to the homepage
    And when I click the "UK Strategy Page" page
    Then I should see the fields filled with the content
      | FIELD                     | VALUE                              |
      | content                   | Test content                       |
      | hero_image                | /assets/styleguide/hero-sample.jpg |
      | hero_description          | Test description                   |
      | teaser_section_title      | Test section title                 |
      | teaser1_title             | Test teaser title 1                |
      | teaser1_image             | /assets/styleguide/hero-sample.jpg |
      | teaser1_text              | Test text                          |
      | teaser1_link              | [Test1](/test1)                    |
      | teaser2_title             | Test tesaer title 2                |
      | teaser2_image             | /assets/styleguide/hero-sample.jpg |
      | teaser2_text              | Test teser text 2                  |
      | teaser2_link              | [Test2](/test2)                    |
      | teaser3_title             | Test teaser title 3                |
      | teaser3_image             | /assets/styleguide/hero-sample.jpg |
      | teaser3_text              | Test teaser text 3                 |
      | teaser3_link              | [Test3](/test3)                    |
      | regional_strategy_title   | Test regional strategy title       |
      | regional_strategy_text    | Test regional strategy text        |
      | regional_strategy_link    | /test-regional-strategy.link       |
      | download                  | [File](a-file)                     |
