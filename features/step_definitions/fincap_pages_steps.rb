Given(/^I have an insight page layout$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'insight',
    label: 'Insight',
    content:  <<-CONTENT
      {{ cms:page:content:rich_text }}
      {{ cms:page:overview }}
      {{ cms:page:countries }}
      {{ cms:page:links_to_research }}
      {{ cms:page:contact_details }}
      {{ cms:page:year_of_publication }}
      {{ cms:page:topics:collection_check_boxes/Saving, Pensions and Retirement Planning, Credit Use and Debt, Budgeting and Keeping Track, Insurance and Protection, Financial Education, Financial Capability }}
      {{ cms:page:countries_of_delivery:collection_check_boxes/United Kingdom, England, Northern Ireland, Scotland, Wales, USA, Other }}
      {{ cms:page:client_groups:collection_check_boxes/Children (3-11), Young People (12-16), Parents / Families, Young Adults (17-24), Working Age (18-65), Older People (65+), Over-indebted people, Social housing tenants, Teachers / practitioners, Other }}
      {{ cms:page:data_types:collection_check_boxes/Quantitative, Qualitative }}
    CONTENT
  )
end

Given(/^I have an evaluation page layout$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'evaluation',
    label: 'Evaluation',
    content: <<-CONTENT
      {{ cms:page:content:rich_text }}
      {{ cms:page:overview }}
      {{ cms:page:countries }}
      {{ cms:page:links_to_research }}
      {{ cms:page:contact_information }}
      {{ cms:page:year_of_publication }}
      {{ cms:page:activities_and_setting }}
      {{ cms:page:programme_delivery }}
      {{ cms:page:countries_of_delivery:collection_check_boxes/United Kingdom, England, Northern Ireland, Scotland, Wales, USA, Other }}
      {{ cms:page:topics:collection_check_boxes/Saving, Pensions and Retirement Planning, Credit Use and Debt, Budgeting and Keeping Track, Insurance and Protection, Financial Education, Financial Capability }}
      {{ cms:page:client_groups:collection_check_boxes/Children (3-11), Young People (12-16), Parents / Families, Young Adults (17-24), Working Age (18-65), Older People (65+), Over-indebted people, Social housing tenants, Teachers / practitioners, Other }}
      {{ cms:page:data_types:collection_check_boxes/Programme Theory, Measured Outcomes, Causality, Process Evaluation, Value for money }}
      {{ cms:page:measured_outcomes:collection_check_boxes/Financial wellbeing, Financial behaviour, Financial capability (connection), Financial capability (mindset), Financial capability (Ability) }}
    CONTENT
  )
end

Given(/^I have a review page layout$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'review',
    label: 'Review',
    content:  <<-CONTENT
      {{ cms:page:content:rich_text }}
      {{ cms:page:overview }}
      {{ cms:page:countries }}
      {{ cms:page:links_to_research }}
      {{ cms:page:contact_information }}
      {{ cms:page:year_of_publication }}
      {{ cms:page:topics:collection_check_boxes/Saving, Pensions and Retirement Planning, Credit Use and Debt, Budgeting and Keeping Track, Insurance and Protection, Financial Education, Financial Capability }}
      {{ cms:page:countries_of_delivery:collection_check_boxes/United Kingdom, England, Northern Ireland, Scotland, Wales, USA, Other }}
      {{ cms:page:client_groups:collection_check_boxes/Children (3-11), Young People (12-16), Parents / Families, Young Adults (17-24), Working Age (18-65), Older People (65+), Over-indebted people, Social housing tenants, Teachers / practitioners, Other }}
      {{ cms:page:data_types:collection_check_boxes/Literature review, Systematic review }}
    CONTENT
  )
end

Given(/^I have an article page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'article',
    label: 'Article',
    content:  <<-CONTENT
      {{ cms:page:content:rich_text }}
      {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
      {{ cms:page:hero_description:simple_component/Description }}
      {{ cms:page:cta_links:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
      {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
      {{ cms:page:feedback:simple_component/email@moneyadviceservice.org.uk.org.uk) }}
    CONTENT
  )
end

Given(/^I am on the homepage$/) do
  home_page.load
end

Given(/^I click on "([^"]*)"$/) do |button|
  click_on(button)
end

Given(/^I select "([^"]*)" on the creation page$/) do |option|
  new_page.select(option)
end

Given(/^I create a page "([^"]*)"$/) do |title|
  new_page.page_name.set(title)
  new_page.save_button.click
end

When(/^I edit the page "([^"]*)"$/) do |title|
  home_page.load
  page.first(:link, title).click
end

When(/^I fill in$/) do |table|
  table.rows.each do |row|
    edit_page.send(row[0]).set(row[1])
  end
end

When(/^I check$/) do |table|
  table.rows.each do |row|
    check(edit_page.send(row[1]).value)
  end
end

Then(/^I should see the checkbox fields with the value$/) do |table|
  table.rows.each do |row|
    if row[1] == 'checked'
      expect(edit_page.send(row[0])).to be_checked
    else
      expect(edit_page.send(row[0])).not_to be_checked
    end
  end
end

When(/^I save and return to the homepage$/) do
  edit_page.save_changes_to_draft.click
  home_page.load
end

When(/^when I click the "([^"]*)" page$/) do |title|
  step(%(I edit the page "#{title}"))
end

Then(/^I should see the fields filled with the content$/) do |table|
  table.rows.each do |row|
    expect(edit_page.send(row[0]).value).to eq(row[1])
  end
end
