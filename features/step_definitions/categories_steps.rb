Given(/^I have an article with(out)? categories$/) do |uncategorized|
  cms_site
  cms_layout
  cms_page
  cms_categories
  cms_page.categories << cms_categories.first unless uncategorized
end

When(/^I visit the article's edit page$/) do
  edit_page.load(site: cms_site.id, page: cms_page.id)
end

Then(/^I should see the article's (new )?category$/) do |is_new|
  expect(edit_page.categories.text).to_not be_empty
  if is_new
    expect(edit_page.categories.text).to match(cms_categories.second.label)
  else
    expect(edit_page.categories.text).to match(cms_categories.first.label)
  end
end

When(/^I add a category to the article$/) do
  edit_page.categories.set cms_categories.first
  edit_page.update.click
end

When(/^I change the article's category$/) do
  edit_page.categories.set cms_categories.second
  edit_page.update.click
end

When(/^I remove the article's categories$/) do
  edit_page.category_remove.click
  edit_page.update.click
end

Then(/^I see no categories listed on the article's page$/) do
  expect(edit_page.category_chosen.text).to be_empty
end
