Feature: Preview
  As a content editor
  I want to see the article I am working on in the actual site
  so that I can see the content as a website visitor would see it

  Scenario: Preview unpublished article
    When I am working on an unpublished article
    And I preview it
    Then I should see the article in a new window as it would appear on the actual site

  Scenario: Preview published article
    When I am working on a published article
    And I preview it
    Then I should see the article in a new window as it would appear on the actual site
