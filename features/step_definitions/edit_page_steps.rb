Then(/^I should be able to preview it in a new window$/) do
  edit_page.should have_preview
  edit_page.preview['href'].should match /#{cms_page.slug}\/preview/
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

Given(/^there is an English and Welsh site$/) do
  cms_sites
end

When(/^I am working on an draft article on the "(.*?)" site$/) do |locale|
  cms_page(locale: locale).save_unsaved!
  edit_page.load(site: cms_site(locale).id, page: cms_page(locale: locale).id)
end

def wait_for_page_load
  find('body[data-dough-component-loader-all-loaded="yes"]')
end

When(/^I switch to the "(.*?)" article$/) do |locale|
  wait_for_page_load
  toggle = locale == "en" ? :site_toggle_en : :site_toggle_cy
  edit_page.send(toggle).click
end

When(/^I should be working on the "(.*?)" article$/) do |locale|
  expect(edit_page.current_url).to match(/\/sites\/#{cms_site(locale).id}\/pages/)
  expect(edit_page.status.text).to match(/#{locale}/i)
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
