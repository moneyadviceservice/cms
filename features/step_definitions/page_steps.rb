When(/^I populate the editor with the text "(.*?)"$/) do |text|
  wait_for_editor
  fill_editor_with(text)
end

When(/^I populate the editor with the markdown$/) do |text|
  wait_for_editor
  fill_editor_with(text, mode: :advanced)
end

When(/^I press the button "(.*?)"$/) do |button_text|
  find_button(button_text).click
end

Then(/^I should see the text "(.*?)" in the editor$/) do |text|
  wait_for_editor
  expect(page).to have_content(text)
end

Then(/^I should see the markdown in the editor$/) do |text|
  wait_for_editor
  expect(edit_page.content.value).to eq(text)
end

Then(/^I should see the button "(.*?)"$/) do |button_text|
  within('.nav-article') do
    expect(page).to have_content(button_text)
  end
end

Then(/^I should not see the button "(.*?)"$/) do |button_text|
  expect(page).not_to have_content(button_text)
end

Then(/^I click the caret to show more buttons$/) do
  # Should see if we can bind a t- id to this
  page.find('.button-menu button.unstyled-button').click
end

Then(/I (?:see|should see) that the state (?:is|is still) "(.*?)"/) do |state_text|
  within('#t-status') do
    expect(page).to have_content(state_text)
  end
end

Then(/^I should see the (.*?) dialogue$/) do |delete_or_remove|
  case delete_or_remove
  when 'deletion'
    expect(page).to have_content("Delete this draft")
  when 'removal'
    expect(page).to have_content("Remove draft")
  when 'schedule'
    expect(page).to have_content('Schedule this post')
  end
end

When(/^I set the schedule time to a time in the future$/) do
  scheduled_on = 1.hour.from_now

  fill_in('scheduled_date', with: scheduled_on.strftime('%d/%m/%Y'))
  fill_in('scheduled_time', with: scheduled_on.strftime('%H:%M'))
end

Then(/^I should be on the live content editing page$/) do
  expect(current_url).not_to match(/alternate=true$/)
end

Then(/^I should be on the alternate content editing page$/) do
  expect(current_url).to match(/alternate=true$/)
end

Then(/^I should see be redirected back to the page index$/) do
  expect(articles_page).to be_displayed
end

Then(/^I should see the latest article in the list$/) do
  article = Comfy::Cms::Page.last
  expect(page).to have_content(article.label)
end

Then(/^I should not see a link to update the draft new version$/) do
  expect(page).not_to have_link('Draft New Version')
end

When(/^I increase the size of my browser window$/) do
  page.driver.resize_window(1920, 1080)
end
