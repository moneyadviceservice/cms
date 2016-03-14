Feature: Email Notification

Scenario: External Editor updates a page
  Given I am an editor user
  And I am working on a new draft article
  When I save changes to the page
  Then an email notification should be sent

Scenario: User updates a page
  Given I am not an admin user
  And I am working on a new draft article
  When I save changes to the page
  Then no email notifications are sent

Scenario: Admin updates a page
  Given I am an admin user
  And I am working on a new draft article
  When I save changes to the page
  Then no email notifications are sent
