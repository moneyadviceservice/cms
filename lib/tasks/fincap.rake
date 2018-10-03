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
          {{ cms:page:contact_information }}
          {{ cms:page:year_of_publication }}
          {{ cms:page:topics:collection_check_boxes/Saving, Pensions and Retirement Planning, Credit Use and Debt, Budgeting and Keeping Track, Insurance and Protection, Financial Education, Financial Capability }}
          {{ cms:page:countries_of_delivery:collection_check_boxes/United Kingdom, England, Northern Ireland, Scotland, Wales, USA, Other }}
          {{ cms:page:client_groups:collection_check_boxes/Children (3 - 11), Young People (12 - 16), Parents / families, Young Adults (17 - 24), Working Age (18 - 65), Older People (65+), Over-indebted people, Social housing tenants, Teachers / practitioners, Other }}
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
        {{ cms:page:client_groups:collection_check_boxes/Children (3 - 11), Young People (12 - 16), Parents / families, Young Adults (17 - 24), Working Age (18 - 65), Older People (65+), Over-indebted people, Social housing tenants, Teachers / practitioners, Other }}
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
        {{ cms:page:client_groups:collection_check_boxes/Children (3 - 11), Young People (12 - 16), Parents / families, Young Adults (17 - 24), Working Age (18 - 65), Older People (65+), Over-indebted people, Social housing tenants, Teachers / practitioners, Other }}
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

    english_site.layouts.find_or_create_by(
      identifier: 'thematic_review',
      label: 'Thematic Review',
      content:  <<-CONTENT
        {{ cms:page:content:rich_text }}
        {{ cms:page:overview }}
        {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
        {{ cms:page:hero_description:simple_component/Description }}
        {{ cms:page:cta_links:simple_component/[Text Link](/en/evidence_hub?tag=something) }}
        {{ cms:page:download:simple_component/[Text Link](link) }}
        {{ cms:page:feedback:simple_component/email@moneyadviceservice.org.uk.org.uk) }}
      CONTENT
    )

    english_site.layouts.find_or_create_by(
      identifier: 'thematic_reviews_landing_page',
      label: 'Thematic Reviews Landing Page',
      content:  <<-CONTENT
        {{ cms:page:content:rich_text }}
        {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
        {{ cms:page:hero_description:simple_component/Thematic Reviews }}
      CONTENT
    )

    english_site.layouts.find_or_create_by(
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
        {{ cms:page:steering_group_title }}
        {{ cms:page:steering_group_links }}
        {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
      CONTENT
    )

    english_site.layouts.find_or_create_by(
      identifier: 'what_works',
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
        {{ cms:page:steering_group_title }}
        {{ cms:page:steering_group_links }}
        {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
      CONTENT
    )

    english_site.layouts.find_or_create_by(
      identifier: 'news',
      label: 'News',
      content:  <<-CONTENT
        {{ cms:page:content:rich_text }}
        {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
        {{ cms:page:hero_description:simple_component/Description }}
        {{ cms:field:order_by_date:datetime }}
        {{ cms:page:cta_links:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
      CONTENT
    )

    english_site.layouts.find_or_create_by(
      identifier: 'latest_news',
      label: 'Latest News',
      content:  <<-CONTENT
        {{ cms:page:content:rich_text }}
        {{ cms:page:hero_image:simple_component/https://moneyadviceservice.org.uk/image.jpg }}
        {{ cms:page:hero_description:simple_component/Description }}
        {{ cms:page:cta_links:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
      CONTENT
    )

    english_site.layouts.find_or_create_by(
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

      english_site.layouts.find_or_create_by(
        identifier: 'uk_strategy',
        label: 'UK Strategy',
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
          {{ cms:page:regional_strategy_title }}
          {{ cms:page:regional_strategy_text }}
          {{ cms:page:regional_strategy_link }}
          {{ cms:page:download:simple_component/[Text Link](https://moneyadviceservice.org.uk/link) }}
        CONTENT
      )

      english_site.layouts.find_or_create_by(
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

  desc 'Fix Evidence Summaries created_at'
  task fix_evidence_summaries_created_at: :environment do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.connection.execute(<<-SQL
      UPDATE
        comfy_cms_pages pages
        INNER JOIN comfy_cms_blocks blocks
          ON blocks.blockable_id = pages.id
          AND blocks.blockable_type = 'Comfy::Cms::Page'
        INNER JOIN comfy_cms_layouts layouts
          ON layouts.id = pages.layout_id
      SET
        pages.created_at = CONCAT(blocks.content, '-01-01 00:00:0')
      WHERE
        layouts.identifier IN ('evaluation', 'insight', 'review')
        AND blocks.identifier = 'year_of_publication'
        AND blocks.content IS NOT NULL
        AND blocks.content != ''
        AND blocks.content < '2018'
    SQL
    )
  end
end
