Feature: Preview
  As a content editor
  I want to see the article I am working on in the actual site
  so that I can see the content as a website visitor would see it

  Scenario: Preview draft article
    When I am working on a Draft Article
    Then I should be able to preview it in a new window
    When I preview the article
    Then I should see the Draft Article
     And I should not be able to see live draft article

  Scenario: Preview published article
    When I am working on a published article
    Then I should be able to preview it in a new window

  Scenario: Preview unpublished article
    Given I have an articles with unpublished changes
    When I view the live published article
    Then I should see the published Article content
