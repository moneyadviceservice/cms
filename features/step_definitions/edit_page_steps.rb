Then(/^I should be able to preview it in a new window$/) do
  edit_page.should have_preview
  edit_page.preview['href'].should match /#{cms_page.full_path}\/preview/
  edit_page.preview['target'].should eq '_blank'
end

When(/^I am working on an draft article$/) do
  cms_site
  cms_page.save_unsaved!
  edit_page.load(site: cms_site.id, page: cms_page.id)
end

When(/^I am working on a published article$/) do
  cms_site
  cms_page.save_unsaved!
  cms_page.publish!
  edit_page.load(site: cms_site.id, page: cms_page.id)
end

Then(/^I should be able to publish it$/) do
  edit_page.should have_publish
  edit_page.publish.click
  expect(cms_page.reload.current_state).to eq(:published)
end
