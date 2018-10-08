Given(/^I click on "([^"]*)"$/) do |button|
  click_on(button)
end

Given(/^I select "([^"]*)" on the creation page$/) do |option|
  new_page.select(option)
end

Given(/^I create a page "([^"]*)"$/) do |title|
  new_page.page_name.set(title)
  new_page.save_button.click
end

When(/^I edit the page "([^"]*)"$/) do |title|
  home_page.load
  page.first(:link, title).click
end

When(/^I fill in$/) do |table|
  table.rows.each do |row|
    edit_page.send(row[0]).set(row[1])
  end
end

When(/^I check$/) do |table|
  table.rows.each do |row|
    check(edit_page.send(row[1]).value)
  end
end

When(/^I uncheck$/) do |table|
  table.rows.each do |row|
    uncheck(edit_page.send(row[1]).value)
  end
end

When(/^I enter an order_by date of "([^"]*)"$/) do |date_string|
  edit_page.order_by_date.set(date_string.to_datetime)
end

When(/^I save and return to the homepage$/) do
  edit_page.save_changes_to_draft.click
  home_page.load
end

When(/^when I click the "([^"]*)" page$/) do |title|
  step(%(I edit the page "#{title}"))
end

Then(/^I should see the fields filled with the content$/) do |table|
  table.rows.each do |row|
    expect(edit_page.send(row[0]).value).to eq(row[1])
  end
end

Then(/^I should see the checkbox fields with the value$/) do |table|
  table.rows.each do |row|
    if row[1] == 'checked'
      expect(edit_page.send(row[0])).to be_checked
    else
      expect(edit_page.send(row[0])).not_to be_checked
    end
  end
end

Then(/^I should see an order_by date of "([^"]*)"$/) do |date_string|
  expect(edit_page.order_by_date.value).to eq(date_string)
end
