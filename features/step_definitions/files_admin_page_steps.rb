When(/^I (?:am on|visit) the files admin page$/) do
  step("I add a new file")
  wait_for_ajax_complete
  @page = files_admin_page
  step("I am logged in")
  @page.load(site: cms_site.id)
end

When(/^I (?:am on|visit) the new file page$/) do
  cms_site
  @page = files_new_page
  step("I am logged in")
  @page.load(site: cms_site.id)
  define_bind rescue nil
  # wait_for_ajax_complete
  # expect(@page).to be_displayed
end

Then(/^I should see a files header$/) do
  expect(@page).to have_files_header
end

Then(/^(?:I should see |also )?a file (.+) section$/) do |section|
  expect(@page).to have_selector(".js-files-#{section}")
end

Then(/^I choose to sort files by name$/) do
  @page.files_filters.form.sort_by.select('name (a to z)') #, :from => 'order')
end

When(/^I add a new file$/) do
  step('I visit the new file page')
  suffix    = Comfy::Cms::File.count
  filelabel = "atestfile_#{suffix}"
  filename  = "animage_#{suffix}.jpeg"
  fill_in("file_label", with: filelabel)
  attach_file('file_file', File.join(Rails.root, 'features', 'support', filename))
  fill_in('file_description', with: "this is the atestfile_#{suffix} description")
  click_link_or_button('Upload File')
  wait_for_ajax_complete
end


# def create_file!
#
#   attach_file(locator, File.join(Rails.root, 'features', 'support', 'animage.jpeg')
#   Comfy::Cms::File.create!(site:        cms_site,
#                            label:       'a new file',
#                            file:        Rack::Test::UploadedFile.new(File.join(Rails.root, 'features', 'support', 'animage.jpeg'), "image/jpeg", true),
#                            description: 'Extraordinaire image')
# end
