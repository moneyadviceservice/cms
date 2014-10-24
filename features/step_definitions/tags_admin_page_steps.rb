When(/^I (?:am on|visit) the tags admin page$/) do
  cms_site
  @page = tags_admin_page
  step("I am logged in")
  @page.load
  define_bind rescue nil
  wait_for_ajax_complete
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
  expect {simulate_create_tag("another-non-existing-tag")}.to change(Tag, :count).by(1)
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
  show_existing_tags(prefix: 'a')
end

Then(/^The list of existing tags(?: starting by that letter)? gets displayed$/) do
  expect(@page.tags_listing.list.tags).not_to be_empty
end

Then (/^The(?: new)? tag must appear in the displayed tag listing$/) do
  expect(Tag.count).to eq(1)
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

Then(/^I delete the tag in the creation box$/) do
  creation_box_tag("another-non-existing-tag").close.click
end

Then(/^I can delete a tag clicking on it$/) do
  expect {click_first_tag_in_listing}.to change(Tag, :count).by(-1)
end

Then(/^The tag should be removed from its displayed listing$/) do
  wait_for_ajax_complete
  expect(@page.tags_listing.list).to have_no_tags
end

Then(/^The same tag in the creation box gets removed$/) do
  expect(creation_box_tags).not_to include('another-non-existing-tag')
end

Then(/^The items tagged with it should lose it$/) do
  expect(Tagging.all.map(&:tag).map(&:value)).not_to include("another-non-existing-tag")
end

def simulate_create_tag(value)
  @page.tags_creation.wait_for_box
  @page.tags_creation.box.native.send_keys(value, :Enter)
  wait_for_ajax_complete
  tag_article!(article: create_article!, tags: [value])
end

def show_existing_tags(prefix:)
  @page.tags_listing.wait_until_tag_index_links_visible
  click_link_or_button(prefix)
  wait_for_ajax_complete
  @page.tags_listing.list.wait_for_tags
end

def click_first_tag_in_listing
  @page.tags_listing.list.wait_for_tags
  @page.tags_listing.list.tags.first.close.click
  wait_for_ajax_complete
end

def creation_box_tags
  @page.tags_creation.tags.map(&:value).map(&:text)
end

def creation_box_tag(value)
  @page.tags_creation.tags.find {|tag| tag.value.text == value}
end

def create_article!
  Comfy::Cms::Page.find_or_create_by(site: cms_site, layout: cms_layout, slug: "first-page")
end

def tag_article!(article:, tags:)
  tags.each {|tag| Tagging.create(taggable: article, tag: Tag.valued(tag).first)}
end
