Given(/^that I am a CMS admin$/) do
  step 'I visit the files admin page'
end

When(/^I upload a file$/) do
  sample = File.join(Rails.root, sample_file)
  add_file sample
end

Then(/^I should see the original url of the file$/) do
  expect(@page).to have_content(uploaded_file_path)
end

def uploaded_file_path
  Comfy::Cms::File.find_by_file_file_name('afile_11.png').file.path
end

def sample_file
  'features/support/files/test/afile_11.png'
end
