When(/^I create a new article$/) do
  site = cms_site.id; cms_layout

  new_page.load(site: site)
end

Then(/^I should be able to publish it$/) do
  new_page.should have_publish
end
