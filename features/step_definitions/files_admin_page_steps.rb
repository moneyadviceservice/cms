When(/^I (?:am on|visit) the files admin page$/) do
  add_some_files
  wait_for_ajax_complete
  @page = files_admin_page
  step("I am logged in")
  @page.load(site: cms_site.id)
  define_bind rescue nil
  wait_for_ajax_complete
end

When(/^I (?:am on|visit) the new file page$/) do
  cms_site
  @page = files_new_page
  step("I am logged in")
  @page.load(site: cms_site.id)
  define_bind rescue nil
  wait_for_page_load rescue nil
  wait_for_ajax
end

Then(/^I should see a files header$/) do
  expect(@page).to have_files_header
end

Then(/^(?:I should see |also )?a file (.+) section$/) do |section|
  expect(@page).to have_selector(".t-files-#{section}")
end

Then(/^I choose to sort files by name$/) do
  @page.files_filters.form.sort_by.select(sort_by_options[:name])
  wait_for_ajax_complete
end

Then(/^I choose to sort files by date$/) do
  @page.files_filters.form.sort_by.select(sort_by_options[:date])
  wait_for_ajax_complete
end

Then(/^(?:The files|They) get (?:sorted|ordered) by name$/) do
  expect(@page.files_filters.form).to have_select('order', :selected => sort_by_options[:name])
  expect(shown_filenames).to eq(sample_filenames.sort)
end

Then(/^(?:The files|They) get (?:sorted|ordered) by date \(latest first\)$/) do
  expect(@page.files_filters.form).to have_select('order', :selected => sort_by_options[:date])
  expect(shown_filenames).to eq(sample_filenames.reverse)
end

Then(/^I choose to filter files by (.+) type$/) do |type|
  @page.files_filters.form.type.select(type)
  wait_for_ajax_complete
end

Then(/^I choose to search files by term$/) do
  simulate_filling_search_term
end

Then(/^Only files with that term are shown$/) do
  expect(@page).to have_field('search', :with => '9')
  expect(shown_filenames).to contain_exactly(*filenames_of_term('9'))
end

Then(/^Only (.+) files are shown$/) do |type|
  expect(@page.files_filters.form).to have_select('type', :selected => type)
  expect(shown_filenames).to contain_exactly(*filenames_of(type: type))
end

Then(/^Only (.+) files sorted by date are shown$/) do |type|
  expect(@page.files_filters.form).to have_select('order', :selected => sort_by_options[:date])
  expect(@page.files_filters.form).to have_select('type',  :selected => type)
  expect(shown_filenames).to eq(filenames_of(type: type).reverse)
end

Then(/^Only (.+) files sorted by name are shown$/) do |type|
  expect(@page.files_filters.form).to have_select('order', :selected => sort_by_options[:name])
  expect(@page.files_filters.form).to have_select('type',  :selected => type)
  expect(shown_filenames).to eq(filenames_of(type: type))
end

When(/^I add a new "(.*?)" file$/) do |type|
  step('I visit the new file page')
  add_file(type: type)
end

def add_some_files
  sample_filenames.each { |filename| add_file(filename) }
end

# Uploads a new file into the system.
def add_file(filename)
  step('I visit the new file page')
  fill_in("file_label", with: filename)
  attach_file('file_file', filename)
  fill_in('file_description', with: sample_file_description(filename))
  click_link_or_button('Upload File')
  wait_for_ajax_complete
end

def file_type_options; %w(doc jpg pdf xls) end
def sort_by_options; { name: 'name (a to z)', date: 'date added (latest first)' } end
def sample_file_description(filename); ['this is the description for file:', filename].join(' ') end
def sample_files_path; File.join(Rails.root, 'features', 'support', 'files', '*') end
def sample_filenames; @filenames ||= Dir.glob(sample_files_path) end
def sample_filenames_string; sample_filenames.join(', ') end

# def doc_filenames
# def pdf_filenames
# ...
file_type_options.each do |type|
  define_method("#{type}_filenames") do
    sample_filenames.find_all { |filename| filename.end_with?(type)}
  end
end

def filenames_of(type:)
  send("#{type}_filenames")
end

def filenames_of_term(term)
  sample_filenames.find_all { |name| name =~ Regexp.new(term) }
end

def shown_filenames
  @page.files_listing.files.map(&:label).map { |el| el['class'].split('t-file t-').last }
end

def simulate_filling_search_term
  @page.wait_for_search_box
  @page.search_box.native.send_keys("9")
  @page.search_button.click
  wait_for_ajax_complete
end
