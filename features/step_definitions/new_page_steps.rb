When(/^I create a new article$/) do
  site = cms_site.id; cms_layout

  new_page.load(site: site)
end

When(/^I upload a word document$/) do
  pending
end

Then(/^I should be able to publish it$/) do
  new_page.should have_publish
end

Then(/^I should be able to upload a word document$/) do
  new_page.should have_upload_word
end

Then(/^I should see its contents inside the CMS editor$/) do
  pending
end

When(/^I fill in "(.*?)" as the meta_description$/) do |value|
  new_page.meta_description.set(value)
end

When(/^I save the article page$/) do
  new_page.page_name.set('New page')
  new_page.create_page.click
end

Then(/^the article's "(.*?)" content should be "(.*?)"$/) do |indentifier, value|
  content = Comfy::Cms::Page.last.blocks.detect {|b| b.identifier == indentifier }.content
  expect(content).to eq(value)
end

