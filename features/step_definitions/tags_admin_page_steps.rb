When(/^I (?:am on|visit) the tags admin page$/) do
  cms_site
  @page = tags_admin_page
  @page.load
  define_bind rescue nil
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
  @page.tags_creation.box.native.send_key("a-non-existing-tag")
end

Then(/^I create a new tag(?: starting by that letter)?$/) do
  simulate_create_tag("another-non-existing-tag")
end

Then(/^I introduce an existing value in the tags creation box$/) do
  simulate_create_tag("an-existing-tag")
  @page.tags_creation.box.native.send_key("an-existing-tag")
end

Then(/^(?:I|The) new tag should be persisted after hitting (.+)$/) do |key_pressed|
  expect do
    @page.tags_creation.box.native.send_key(key_pressed.capitalize.to_sym)
    wait_for_ajax_complete
  end.to change(Tag, :count).by(1)
end

Then(/^(?:I|The) new tag should not be persisted$/) do
  expect do
    @page.tags_creation.box.native.send_key(:Enter)
    wait_for_ajax_complete
  end.not_to change(Tag, :count)
end

And(/^There are tags starting by a certain letter$/) do
  simulate_create_tag("an-existing-tag")
end

And(/^No tags starting by a certain letter exist$/) do
  expect(Tag.starting_by('a')).not_to be_present
end

Then(/^I click on (?:a|the) letter to list the tags starting by (?:it|the same letter)$/) do
  show_existing_tags
end

Then(/^The list of existing tags(?: starting by that letter)? gets displayed$/) do
  expect(@page.tags_listing.list.tags).not_to be_empty
end

Then (/^The(?: new)? tag must appear in the displayed tag listing$/) do
  expect(@page.tags_listing.list.tags).not_to be_empty
end

Then(/^A 'void list' message get displayed$/) do
  expect {@page.tags_listing.header.existing_tags_msg}.to raise_error
  expect(@page.tags_listing.header.no_tags_msg).to be_present
end

Then(/^No tags (?:are|get) displayed$/) do
  expect(@page.tags_listing.list.tags).to be_empty
end

Then(/^I delete (?:the first tag|it|the tag in the listing)$/) do
  click_first_tag_in_listing
end

Then(/^I can delete a tag clicking on it$/) do
  expect {click_first_tag_in_listing}.to change(Tag, :count).by(-1)
end

Then(/^The tag should be removed from its displayed listing$/) do
  wait_for_ajax_complete
  expect(@page.tags_listing.list.tags).to be_empty
end

def simulate_create_tag(value)
  @page.tags_creation.wait_for_box
  @page.tags_creation.box.native.send_keys(value, :Enter)
  wait_for_ajax_complete
end

def show_existing_tags
  @page.click_link('a')
  wait_for_ajax_complete
end

def click_first_tag_in_listing
  tag_value = @page.tags_listing.list.tags.first.value.text
  @page.click_link("js_tags_delete_#{tag_value}")
  wait_for_ajax_complete
end
