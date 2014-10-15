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
  @page.tags_creation.box.set("a-non-existing-tag")
end

Then(/^I introduce an existing value in the tags creation box$/) do
  @page.tags_creation.wait_for_box
  @page.tags_creation.box.set("an-existing-tag")
end

When(/^I submit the tag$/) do
  @page.tags_creation.submit_button.click
end

Then(/^The new tag should be persisted$/) do
  wait_for_ajax_complete
  expect(Tag.count).to eq(1)
end

Then(/^(?:I|The) new tag should not be persisted$/) do
  expect {@page.tags_creation.box.trigger(:Enter)}.not_to change(Tag, :count)
end


def wait_for_ajax_complete
  Timeout.timeout(Capybara.default_wait_time) do
    loop until page.evaluate_script('$.active').zero?
  end
end
