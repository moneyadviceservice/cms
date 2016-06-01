@javascript
Feature: Link to existing articles
  As a CMS user editing or creating a page
  I want to be able to insert a link to an existing articles
  So that I can link my article to other articles

Scenario: Linking to a scheduled article
  Given I have a scheduled article with the slug "Scheduled-Article-to-Link"
    And I am working on a new draft article
    And I populate the editor with the text "anything really"
  When I press the button "Insert link"
   And I type "Scheduled" into the search input
  Then I should see "Scheduled-Article-to-Link" in the list of linkable pages

Scenario: Linking to an article with scheduled mirror
  Given there is an English and Welsh site
    And I have a published article "link-to-language-test" in "en"
    And I have a scheduled update to the "cy" mirror of "link-to-language-test"
  When I edit a new draft article
   And I populate the editor with the text "anything really"
   And I press the button "Insert link"
   And I type "link-to-language" into the search input
  Then I should see "link-to-language-test" in the list of linkable pages
   And the "en" and "cy" versions are available for linking

