Given(/^that I am a CMS admin$/) do
  step 'I visit the files admin page'
end

When(/^I upload a file$/) do
  sample = File.join(Rails.root, 'features/support/files/test/afile_11.png')
  add_file sample
end

Then(/^I should see the original url of the file$/) do
  uploaded_file_path = Comfy::Cms::File.find_by_file_file_name('afile_11.png').file.path

  expect(@page).to have_content(uploaded_file_path)
end
