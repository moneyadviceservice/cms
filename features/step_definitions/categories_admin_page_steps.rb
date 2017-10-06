When(/^I visit the categories admin page$/) do
  cms_site
  create_categories
  @page = categories_admin_page
  step("I am logged in")
  @page.load
  define_bind rescue nil
  wait_for_ajax_complete
  expect(@page).to be_displayed
end

When(/^I select a category$/) do
  @page.category_links.first.click
end

Then(/^I should not be able to select that category as the parent category$/) do
  @page = category_details_page
  @page.load(id: Comfy::Cms::Category.first.id)
  expect(@page.parent_options[1].disabled?).to be_truthy
  expect(@page.parent_options[2].disabled?).to be_falsey
end

def create_categories
  2.times do |n| 
    Comfy::Cms::Category.create(
      site: cms_site,
      label: "label-#{n}",
      title_en: "en-label-#{n}",
      title_cy: "cy-label-#{n}",
      categorized_type: "Comfy::Cms::Page"
    )
  end
end
