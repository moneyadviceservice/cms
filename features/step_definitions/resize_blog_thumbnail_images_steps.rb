Given(/^that I am a CMS admin$/) do
  step 'I visit the new file page'
end

When(/^I upload a file$/) do
  sample_file = File.join(Rails.root, 'features/support/files/test/afile_11.png')
  add_file sample_file
end

Then(/^I should have an image with varying sizes "([^"]*)"$/) do |size|
  expect(@page).to have_content('Files uploaded')
  expect(@page).to have_content(size)
end
