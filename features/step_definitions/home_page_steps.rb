Given(/^I (?:am on|visit) the home page$/) do
  step("I am logged in")
  home_page.load
end

Then(/^I should be in the sites section$/) do
  expect(home_page.header.title.text).to match(/site/i)
end

Then(/^I should not be able to create a new page$/) do
  expect(home_page).not_to have_content('Create new page')
end
