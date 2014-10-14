When(/^I (?:am on|visit) the tags admin page$/) do
  cms_site
  @page = tags_admin_page
  @page.load
  expect(@page).to be_displayed
end

Then(/^I should see a tags header$/) do
  expect(@page).to have_tags_header
end

Then(/^(?:I should see |also )?a tags (.+) section$/) do |section|
  expect(@page).to have_selector(".js-tags-#{section}")
end

Then(/^I introduce a non-existing value in the tags creation box$/) do
  @page.tags_creation.wait_for_box
  @page.tags_creation.box.native.send_key("a-tag")
end

Then(/^I introduce an existing value in the tags creation box$/) do
  @page.tags_creation.wait_for_box
  @page.tags_creation.box.native.send_key("a-tag")
end

Then(/^(?:I|The) new tag should be persisted$/) do
  expect {@page.tags_creation.box.native.send_key(:Enter)}.to change(Tag, :count).by(1)
end

Then(/^(?:I|The) new tag should not be persisted$/) do
  expect {@page.tags_creation.box.native.send_key(:Enter)}.not_to change(Tag, :count)
end
