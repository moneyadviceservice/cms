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
