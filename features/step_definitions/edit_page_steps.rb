When(/^I am (?:working on|editing) an? (un)?published article$/) do |unpublished|
  cms_site
  cms_page(published: unpublished.nil?)
  edit_page.load(site: cms_site.id, page: cms_page.id)
end

Then(/^I should be able to preview it in a new window$/) do
  edit_page.should have_preview
  edit_page.preview['href'].should match /#{cms_page.full_path}\/preview/
  edit_page.preview['target'].should eq '_blank'
end
