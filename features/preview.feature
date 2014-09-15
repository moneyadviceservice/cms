Feature: Preview
  As a content editor
  I want to see the article I am working on in the actual site
  so that I can see the content as a website visitor would see it

  Scenario: Preview draft article
    When I am working on an draft article
    Then I should be able to preview it in a new window

  Scenario: Preview published article
    When I am working on a published article
    Then I should be able to preview it in a new window
