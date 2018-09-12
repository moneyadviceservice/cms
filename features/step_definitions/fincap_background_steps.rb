Given(/^I am on the homepage$/) do
  home_page.load
end

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

Given(/^I have an thematic reviews landing page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'thematic_reviews_landing_page',
    label: 'Thematic Reviews Landing Page',
    content:  <<-CONTENT
      {{ cms:page:content:rich_text }}
    CONTENT
  )
end

Given(/^I have a lifestage page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'lifestage',
    label: 'Lifestage',
    content:  <<-CONTENT
      {{ cms:page:content:rich_text }}
      {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
      {{ cms:page:hero_description:simple_component/Description }}
      {{ cms:page:teaser_section_title }}
      {{ cms:page:teaser1_title }}
      {{ cms:page:teaser1_image }}
      {{ cms:page:teaser1_text }}
      {{ cms:page:teaser1_link }}
      {{ cms:page:teaser2_title }}
      {{ cms:page:teaser2_image }}
      {{ cms:page:teaser2_text }}
      {{ cms:page:teaser2_link }}
      {{ cms:page:teaser3_title }}
      {{ cms:page:teaser3_image }}
      {{ cms:page:teaser3_text }}
      {{ cms:page:teaser3_link }}
      {{ cms:page:strategy_title }}
      {{ cms:page:strategy_overview }}
      {{ cms:page:strategy_link }}
      {{ cms:page:steering_group_list_title }}
      {{ cms:page:steering_group_links }}
      {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
    CONTENT
  )
end

Given(/^I have a what works page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'what_woks',
    label: 'What Works',
    content:  <<-CONTENT
      {{ cms:page:content:rich_text }}
      {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
      {{ cms:page:hero_description:simple_component/Description }}
      {{ cms:page:teaser_section_title }}
      {{ cms:page:teaser1_title }}
      {{ cms:page:teaser1_image }}
      {{ cms:page:teaser1_text }}
      {{ cms:page:teaser1_link }}
      {{ cms:page:teaser2_title }}
      {{ cms:page:teaser2_image }}
      {{ cms:page:teaser2_text }}
      {{ cms:page:teaser2_link }}
      {{ cms:page:teaser3_title }}
      {{ cms:page:teaser3_image }}
      {{ cms:page:teaser3_text }}
      {{ cms:page:teaser3_link }}
      {{ cms:page:strategy_title }}
      {{ cms:page:strategy_overview }}
      {{ cms:page:strategy_link }}
      {{ cms:page:steering_group_list_title }}
      {{ cms:page:steering_group_links }}
      {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
    CONTENT
  )
end

Given(/^I have a news page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'news',
    label: 'News',
    content:  <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:order_by_date }}
    {{ cms:page:cta_links:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
  CONTENT
  )
end

Given(/^I have a latest news page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'latest_news',
    label: 'Latest News',
    content:  <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:cta_links:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
  CONTENT
  )
end

Given(/^I have a regional strategy page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'regional_strategy',
    label: 'Regional Strategy',
    content: <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:teaser_section_title }}
    {{ cms:page:teaser1_title }}
    {{ cms:page:teaser1_image }}
    {{ cms:page:teaser1_text }}
    {{ cms:page:teaser1_link }}
    {{ cms:page:teaser2_title }}
    {{ cms:page:teaser2_image }}
    {{ cms:page:teaser2_text }}
    {{ cms:page:teaser2_link }}
    {{ cms:page:teaser3_title }}
    {{ cms:page:teaser3_image }}
    {{ cms:page:teaser3_text }}
    {{ cms:page:teaser3_link }}
    {{ cms:page:strategy_title }}
    {{ cms:page:strategy_text }}
    {{ cms:page:strategy_link }}
    {{ cms:page:forum_title}}
    {{ cms:page:forum_links}}
    {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
  CONTENT
  )
end

Given(/^I have a homepage page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'homepage',
    label: 'Homepage',
    content: <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:teaser_section_title }}
    {{ cms:page:teaser1_title }}
    {{ cms:page:teaser1_image }}
    {{ cms:page:teaser1_text }}
    {{ cms:page:teaser1_link }}
    {{ cms:page:teaser2_title }}
    {{ cms:page:teaser2_image }}
    {{ cms:page:teaser2_text }}
    {{ cms:page:teaser2_link }}
    {{ cms:page:teaser3_title }}
    {{ cms:page:teaser3_image }}
    {{ cms:page:teaser3_text }}
    {{ cms:page:teaser3_link }}
    {{ cms:page:horizontal_teaser_title }}
    {{ cms:page:horizontal_teaser_image }}
    {{ cms:page:horizontal_teaser_text }}
    {{ cms:page:horizontal_teaser_link }}
  CONTENT
  )
end

Given(/^I have a uk strategy page layout setup with components$/) do
  cms_site.layouts.find_or_create_by(
    identifier: 'uk-strategy',
    label: 'UK Strategy',
    content: <<-CONTENT
    {{ cms:page:content:rich_text }}
    {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
    {{ cms:page:hero_description:simple_component/Description }}
    {{ cms:page:teaser_section_title:simple_component/Financial capability in action }}
    {{ cms:page:teaser1_title }}
    {{ cms:page:teaser1_image }}
    {{ cms:page:teaser1_text }}
    {{ cms:page:teaser1_link }}
    {{ cms:page:teaser2_title }}
    {{ cms:page:teaser2_image }}
    {{ cms:page:teaser2_text }}
    {{ cms:page:teaser2_link }}
    {{ cms:page:teaser3_title }}
    {{ cms:page:teaser3_image }}
    {{ cms:page:teaser3_text }}
    {{ cms:page:teaser3_link }}
    {{ cms:page:regional_strategy_title }}
    {{ cms:page:regional_strategy_text }}
    {{ cms:page:regional_strategy_link }}
    {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
  CONTENT
  )
end
