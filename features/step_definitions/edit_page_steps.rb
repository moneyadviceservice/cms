When(/^I am (?:working on|editing) an? (un)?published article$/) do |unpublished|
  site = cms_site.id
  page = cms_page(unpublished.nil?).id

  edit_page.load(site: site, page: page)
end

When(/^I preview it$/) do
  edit_page.preview.click
end

Then(/^I should see the article in a new window as it would appear on the actual site$/) do
  # page.within_window 'other_window' do
  #   current_url.should match /example.com/
  # end
end
