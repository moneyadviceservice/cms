Given(/^I (?:am on|visit) the home page$/) do
  step("I am logged in")
  home_page.load
end

Then(/^I should be in the sites section$/) do
  expect(home_page.header.title.text).to match(/site/i)
end
