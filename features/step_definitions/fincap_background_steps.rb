layouts = YAML::load_file("#{Rails.root}/config/fincap_layouts.yml")

Given(/^I am on the homepage$/) do
  home_page.load
end
Given(/^I have an insight page layout$/) do
  cms_site.layouts.find_or_create_by(layouts[:insight])
end

Given(/^I have an evaluation page layout$/) do
  cms_site.layouts.find_or_create_by(layouts[:evaluation])
end

Given(/^I have a review page layout$/) do
  cms_site.layouts.find_or_create_by(layouts[:review])
end

Given(/^I have an article page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:article])
end

Given(/^I have an thematic reviews landing page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:thematic_reviews_landing_page])
end

Given(/^I have a lifestage page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:lifestage])
end

Given(/^I have a what works page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:what_works])
end

Given(/^I have a news page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:news])
end

Given(/^I have a latest news page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:latest_news])
end

Given(/^I have a regional strategy page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:regional_strategy])
end

Given(/^I have a homepage page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:homepage])
end

Given(/^I have a uk strategy page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(layouts[:uk_strategy])
end
