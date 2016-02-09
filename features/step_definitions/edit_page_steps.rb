Then(/^I should be able to preview it in a new window$/) do
  edit_page.should have_preview
  edit_page.preview['href'].should match /#{cms_page.slug}\/preview/
  edit_page.preview['target'].should eq '_blank'
end

When(/^I preview the article$/) do
  preview_page.load(locale: cms_site.label, slug: cms_page.slug)
end

Then(/^I should see the Draft Article$/) do
  expect(JSON.parse(preview_page.text)['blocks'].find {|b| b["identifier"] == 'content'}['content']).to include('test')
end

Then(/^I should not be able to see live draft article$/) do
  live_page.load(locale: cms_site.label, slug: cms_page.slug)
  expect(JSON.load(live_page.text).symbolize_keys).to eq(message: 'Page not found')
end

Given(/^I have an articles with unpublished changes$/) do
  edit_page.load(site: cms_site.id, page: cms_draft_page.id)
  edit_page.content.set("New Published Content")
  edit_page.publish.click
  edit_page.content.set("New unpublished Content")
  edit_page.save_changes.click
end

When(/^I view the live published article$/) do
  live_page.load(locale: cms_site.label, slug: cms_page.slug)
end

Then(/^I should see the published Article content$/) do
  expect(JSON.parse(live_page.text)['blocks'].find {|b| b["identifier"] == 'content'}['content']).to include('New Published Content')
end

When(/^I am working on a Draft Article$/) do
  edit_page.load(site: cms_site.id, page: cms_draft_page.id)
end

When(/^I am working on a published article$/) do
  edit_page.load(site: cms_site.id, page: cms_published_page.id)
end

When(/^I publish the article$/) do
  edit_page.publish.click
end

When(/^I save changes to the page$/) do
  edit_page.save_changes_button.click
end

Then(/^I should be able to publish it$/) do
  edit_page.should have_publish
  edit_page.publish.click
  expect(cms_page.reload.current_state).to eq(:published)
end

Then(/^I should be able to see the last revision status$/) do
  edit_page.activity_log_button.click
  expect(edit_page.activity_log_box).to have_content('Status: published')
end

Given(/^there is an English and Welsh site$/) do
  cms_sites
end

When(/^I am working on a Draft Article on the "(.*?)" site$/) do |locale|
  cms_page(locale: locale).save_unsaved!
  step("I am logged in")
  edit_page.load(site: cms_site(locale).id, page: cms_page(locale: locale).id)
end

When(/^I switch to the "(.*?)" article$/) do |locale|
  wait_for_page_load
  toggle = locale == "en" ? :site_toggle_en : :site_toggle_cy
  edit_page.send(toggle).click
end

When(/^I should be working on the "(.*?)" article$/) do |locale|
  sleep(0.1) # wait for page to load
  expect(edit_page.status.text).to match(/#{locale}/i)
  expect(edit_page.current_url).to match(/\/sites\/#{cms_site(locale).id}\/pages/)
end

Given(/^I (select|deselect) the regulated check box$/) do |selection|
  edit_page.regulated_checkbox.set(selection == "select")
  edit_page.publish.click
end

Then(/^the article should( not)? be regulated$/) do |negate|
  expect(cms_page.reload.regulated?).to be !!!negate
end

Given(/^the article is regulated$/) do
  cms_page.update_attributes!(regulated: true)
end

Then(/^an email notification should be sent$/) do
  expect(ActionMailer::Base.deliveries.last.subject).to include('Content updated by External Editor')
end

Then(/^no email notifications are sent$/) do
  expect(ActionMailer::Base.deliveries).to be_empty
end
