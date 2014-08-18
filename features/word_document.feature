Feature: As a content editor
  I want to upload a word document that follows the guidelines
  and have its contents imported and formatted into the CMS editor
  so that I don't have to copy, paste and format the content manually

  Scenario: Ability to upload word document from new article
    When I create a new article
    Then I should be able to upload a word document

  Scenario: Upload word document
    Given I create a new article
    When I upload a word document
    Then I should see its contents inside the CMS editor
