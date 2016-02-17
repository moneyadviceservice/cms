Feature: Site switch
  As a content editor
  I want to be able to edit English and Welsh articles
  so that website visitors can read it

  @javascript
  Scenario Outline: Switch article site
    Given there is an English and Welsh site
    When I am working on a new draft article on the "<current_locale>" site
    When I switch to the "<switch_to_locale>" article
    And I should be working on the "<switch_to_locale>" article

    Examples:
     | current_locale | switch_to_locale |
     | en             | cy               |
     | cy             | en               |
