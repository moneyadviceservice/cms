When(/^I am (?:working on|editing) an? (un)?published article$/) do |unpublished|
  site = cms_site.id
  page = cms_page(unpublished.nil?).id

  edit_page.load(site: site, page: page)
end

Then(/^I should be able to preview it in a new window$/) do
  edit_page.should have_preview
  edit_page.preview['href'].should match /#{cms_page.full_path}\/preview/
  edit_page.preview['target'].should eq '_blank'
end
