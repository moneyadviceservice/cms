Feature: Resize blog thumbnail image
  As a user with limited bandwidth,
  In order to save time when looking for advice on personal finance.
  I want the web pages to load faster whilst browsing.

Scenario Outline: create a duplicate image of the original image
  Given that I am a CMS admin
  When I upload a file
  Then I should have an image with varying sizes "<size>"

  Examples:
    | size        |
    | Extra small |
    | Small       |
    | Medium      |
    | Large       |
