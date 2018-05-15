namespace :fincap do
  desc 'Setup fincap data'
  task setup: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    Comfy::Cms::User.create_with(password: 'password', role: 'admin').find_or_create_by!(email: 'user@test.com')

    english_site = Comfy::Cms::Site.find_or_create_by(
      label: 'en',
      identifier: 'money-advice-service-en',
      hostname: ENV['HOSTNAME'] || 'localhost:3000',
      path: 'en',
      locale: 'en',
      is_mirrored: true
    )

    %w(insight).each do |layout|
      english_site.layouts.find_or_create_by(
        identifier: layout,
        label: layout.titleize,
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

    english_site.layouts.find_or_create_by(
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

    english_site.layouts.find_or_create_by(
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

    english_site.layouts.find_or_create_by(
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
end
