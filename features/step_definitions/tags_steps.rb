When(/^Mirrored sites$/) do
  cms_sites
end

When(/^I (?:am on|visit) the new page$/) do
  loging_in_user do
    @page = new_page
    @page.load(site: cms_site.id)
  end
end

Then(/^I am editing a page$/) do
  loging_in_user do
    @page = edit_page
    @page.load(site: cms_site.id, page: build_cms_page.id)
  end
end

Then(/^There are available tags$/) do
  create_tag("a-tag")
  expect(Tag.any?).to be_truthy
end

Then(/^There are no available tags$/) do
  Tag.destroy_all
  expect(Tag.any?).to be_falsy
end

Then(/^I should not see a tags field to fill in$/) do
  expect(@page).not_to have_tags_choices
  expect(@page).not_to have_tags_chosen
end

Then(/^I should see a tags field to fill in$/) do
  expect(@page).to have_tags_choices
end

Then(/^I associate no tags in the tagging box$/) do
  expect(@page).not_to have_tags_chosen
end

Then(/^I enter some tags in the tagging box$/) do
  simulate_associate_tag("a-tag")
end

When(/^I should be able to save the page$/) do
  expect { click_save_button }.to change(Comfy::Cms::Page, :count)
end

When(/^I should be able to save the page changes$/) do
  click_save_button(name_page: false)
  step("The page gets associated to them")
end

When(/^The(?: new)? page get(?:s)? associated to them$/) do
  dbpage = cms_site.pages.where(label: @page_name).first
  expect(dbpage).to be_present
  expect(dbpage.keywords.map(&:value)).to contain_exactly(*@page_tags)
end

When(/^The welsh version too$/) do
  dbpage = cms_site('cy').pages.where(label: @page_name).first
  expect(dbpage).to be_present
  expect(dbpage.keywords.map(&:value)).to contain_exactly(*@page_tags)
end

def create_tag(value)
  Tag.create(value: value)
end

def simulate_associate_tag(value)
  @page.wait_for_tags_input_box
  @page.tags_input_box.click
  wait_for_ajax_complete
end

def click_save_button(name_page: true)
  @page.page_name.set('This is a new page') if (name_page && @page.respond_to?(:page_name))
  @page_name = @page.page_name.value
  @page_tags = @page.tags_chosen.map(&:text)
  @page.save_button.click
  wait_for_ajax_complete
end
