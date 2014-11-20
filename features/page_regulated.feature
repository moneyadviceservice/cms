Feature: Regulated content
  As a CMS user editing or creating a page
  I can flag if a page is regulated or not
  So this page can be flagged when exporting content

  Scenario: Regulating a page
    Given I am working on a Draft Article
    And I select the regulated check box
    Then the article should be regulated

  Scenario: Turning off regulation of a page
    Given I am working on a Draft Article
    And the article is regulated
    And I deselect the regulated check box
    Then the article should not be regulated
