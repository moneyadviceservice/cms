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
  load_page_in_editor(site: cms_site, page: cms_new_draft_page).slug
  edit_page.content.set("New Published Content")
  edit_page.publish.click
  edit_page.content.set("New unpublished Content")
  edit_page.create_new_draft.click
end

Given(/^I have a scheduled article with the slug "([\w\s-]+)"/) do |title|
  build_cms_scheduled_page(identifier: title)
end

Given(/^I have a published article "([\w\s-]+)" in "([a-zA-Z]{2})"$/) do |slug, locale|
  build_cms_published_page(identifier: slug, locale: locale)
end

Given(/^I have a scheduled update to the "([a-zA-Z]{2})" mirror of "([\w\s-]+)"$/) do |slug, locale|
  build_cms_scheduled_page(identifier: slug, locale: locale)
end

Given(/^the published article has a "([a-zA-Z]{2})" update scheduled$/) do |locale|
  cms_scheduled_page(identifier: title)
end

When(/^I view the live published article$/) do
  live_page.load(locale: cms_site.label, slug: cms_page.slug)
end

Then(/^I should see the published Article content$/) do
  expect(JSON.parse(live_page.text)['blocks'].find {|b| b["identifier"] == 'content'}['content']).to include('New Published Content')
end

When(/^I (?:am working on|edit) a new unsaved article$/) do
  load_page_in_editor(page: cms_new_unsaved_page)
end

When(/^I (?:am working on|edit) a new draft article$/) do
  load_page_in_editor(page: cms_new_draft_page)
end

When(/^I (?:am working on|edit) a published article$/) do
  load_page_in_editor(page: cms_published_page)
end

When(/^I (?:am working on|edit) a scheduled but not live article$/) do
  load_page_in_editor(page: cms_scheduled_page)
end

When(/^I (?:am working on|edit) a scheduled and live article$/) do
  load_page_in_editor(page: cms_scheduled_page(live: true))
end

When(/^I (?:am working on|edit) a draft new version of an article$/) do
  load_alternate_page_in_editor(page: cms_draft_version_of_page)
end

When(/^I (?:am working on|edit) a scheduled update to an article$/) do
  load_alternate_page_in_editor(page: cms_scheduled_new_version_of_page)
end

When(/^I (?:am working on|edit) a live scheduled update to an article$/) do
  load_page_in_editor(page: cms_scheduled_new_version_of_page(live: true))
end

When(/^I publish the article$/) do
  edit_page.publish.click
end

When(/^I save changes to the page$/) do
  edit_page.save_changes_to_draft.click
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

When(/^I type "(.*?)" into the search input$/) do |text|
  edit_page.link_manager.pages.search_input_box.set(text)
  edit_page.link_manager.pages.search_button.click
  wait_for_ajax
end

Given(/^there is an English and Welsh site$/) do
  cms_sites
end

When(/^I (?:am working on|edit) a new draft article on the "(.*?)" site$/) do |locale|
  cms_page(locale: locale).create_initial_draft!
  step("I am logged in")
  load_page_in_editor(
    page: cms_page(locale: locale),
    site: cms_site(locale)
  )
end

When(/^I switch to the "(.*?)" article$/) do |locale|
  wait_for_page_load
  toggle = locale == "en" ? :site_toggle_en : :site_toggle_cy
  edit_page.send(toggle).click
end

When(/^I should be working on the "(.*?)" article$/) do |locale|
  wait_for_page_load
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

Then(/^I should be able to delete the article$/) do
  expect(edit_page).to have_delete_page
end

Then(/^I should not be able to delete the article$/) do
  expect(edit_page).not_to have_delete_page
end

Then(/^I should be able to schedule the article$/) do
  expect(edit_page).to have_schedule
end

Then(/^I should not be able to schedule the article$/) do
  expect(edit_page).not_to have_schedule
end

Then(/^an email notification should be sent$/) do
  expect(ActionMailer::Base.deliveries.last.subject).to include('Content updated by External Editor')
end

Then(/^no email notifications are sent$/) do
  expect(ActionMailer::Base.deliveries).to be_empty
end

Then(/^I should see "(.*?)" in the list of linkable pages/) do |name|
  @linkable_page = edit_page.link_manager.pages.results.find do |row|
    row.page_name.text.include? name
  end
  expect(@linkable_page).to_not be_nil
end

Then(/^the "([a-zA-Z]{2})" and "([a-zA-Z]{2})" versions are available for linking$/) do |*locales|
  locales.each do |locale|
    expect(@linkable_page.send(locale)).
      to have_field("page_radio_button_name__#{locale}_articles_link-to-language-test")
  end
end

