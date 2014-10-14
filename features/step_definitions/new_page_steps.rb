When(/^I create a new article$/) do
  site = cms_site.id; cms_layout
  step("I am logged in")
  new_page.load(site: site)
end

When(/^I upload a word document$/) do
  pending
end

Then(/^I should not be able to publish it$/) do
  new_page.should_not have_publish
end

Then(/^I should be able to upload a word document$/) do
  new_page.should have_upload_word
end

Then(/^I should see its contents inside the CMS editor$/) do
  pending
end

When(/^I fill in "(.*?)" as the meta_(.*)$/) do |value, field|
  new_page.send(("meta_" + field).to_sym).set(value)
end

When(/^I save the article page$/) do
  new_page.page_name.set('New page')
  new_page.save.click
end

Then(/^the article's "(.*?)" should be "(.*?)"$/) do |field, value|
  expect(Comfy::Cms::Page.last.send(field.to_sym)).to eq(value)
end

