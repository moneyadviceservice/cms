FactoryGirl.define do
  factory :page, class: Comfy::Cms::Page do
    site
    layout
    label 'Default Page'
    full_path '/'
    sequence(:slug) { |n| "a-page-#{n}" }
    children_count 1
    position 0
    is_published true
    state :published
    content_cache %(
      layout_content_a
      default_page_text_content_a
      default_snippet_content
      default_page_text_content_b
      layout_content_b
      default_snippet_content
      layout_content_c
    )

    transient do
      tag_name 'tag'
    end

    factory :page_with_tag do
      layout { create :layout, identifier: 'article' }
      after(:create) do |page, evaluator|
        page.keywords << create(:tag, value: evaluator.tag_name)
        page.reload
      end
    end

    factory :page_with_multiple_tags do
      site { create :site, identifier: 'test-documents' }
      label 'A page with two tags'
      after(:create) do |page, evaluator|
        page.keywords.concat [
          create(:tag, value: "#{evaluator.tag_name}-2"),
          create(:tag, value: "#{evaluator.tag_name}-3")
        ]
        create :block, identifier: 'content', blockable: page
      end
    end

    factory :english_article do
      site { create :site, label: 'en' }
      layout { create :layout, identifier: 'article' }
    end

    factory :welsh_article do
      site { create :site, :welsh }
      layout { create :layout, identifier: 'article' }
    end

    factory :article_with_metadata do
      site { create :site, label: 'en' }
      layout { create :layout, identifier: 'video' }
      label 'Video Page Added'
      slug 'video-page-added'
      full_path '/video-page-added'
      meta_description 'Just a meta description'
      meta_title 'Meta title'
      meta_keywords 'Csv, test'
    end

    factory :homepage do
      site { create :site, identifier: 'test-homepage' }
      after(:create) do |page|
        create :block, identifier: 'raw_tile_1_label', blockable: page
        create :block, identifier: 'raw_tile_1_image', content: 'http://e.co/original/uc.jpg', blockable: page
        create :block, identifier: 'raw_tile_1_url', blockable: page
        create :block, identifier: 'raw_tile_1_heading', blockable: page
        page.reload
      end
    end

    factory :page_abt_debt_and_stress do
      site { create :site, identifier: 'test-documents' }
      label 'Debt, stress and pay levels'
      after(:create) do |page|
        create :block, :debt_content, blockable: page
        create :block, :working_age_client_group, blockable: page
      end
    end

    factory :uk_study_about_work_and_stress do
      site { create :site, identifier: 'test-documents' }
      label 'Debt, stress and pay levels in the UK'
      after(:create) do |page|
        create :block, :debt_content, blockable: page
        create :block, :working_age_client_group, blockable: page
        create :block, :saving_topic, blockable: page
        create :block, :published_by_uk, blockable: page
      end
    end

    factory :insight_page do
      site { create :site, identifier: 'test-documents' }
      layout { create :layout, identifier: 'insight' }

      after(:create) do |page|
        create :block, :financial_wellbeing_content, blockable: page
      end

      factory :insight_page_about_pensions do
        after(:create) do |page|
          create :block, :pension_content, blockable: page
        end
      end

      factory :insight_page_titled_pensions do
        label 'pensions'
        after(:create) do |page|
          create :block, :debt_content, blockable: page
        end
      end

      factory :insight_page_titled_annuities do
        label 'Annuities'
        after(:create) do |page|
          create :block, identifier: 'content', blockable: page
        end
      end

      factory :insight_page_with_overview_block do
        label 'Overview'
        after(:create) do |page|
          create :block, :redundancy_overview, blockable: page
          create :block, :redundancy_topic, blockable: page
        end
      end

      factory :insight_page_with_raw_cta_text_block do
        label 'Page with block other than content or identifier'
        after(:create) do |page|
          create :block, :raw_cta_text_content, blockable: page
        end
      end

      factory :insight_page_with_year_of_publication do
        transient do
          year { '2018' }
        end

        after(:create) do |page, evaluator|
          create :block,
                 :year_of_publication,
                 content: evaluator.year,
                 blockable: page
        end
      end
    end

    factory :page_with_order_by_date_block do
      site { create :site, identifier: 'test-documents' }
      label 'Some label'
      transient { order_by_date '2017-03-15' }
      after(:create) do |page, evaluator|
        page.keywords << Tag.find_or_create_by(value: 'test')
        create :block, identifier: 'content', blockable: page
        create(
          :block,
          :order_by_date,
          content: evaluator.order_by_date,
          blockable: page
        )
      end
    end

    factory :young_adults_page do
      site { create :site, identifier: 'test-documents' }
      label 'Debt about young adults and stress'
      after(:create) do |page|
        create :block, :young_adults_client_group, blockable: page
      end
    end
  end

  factory :child_page, class: Comfy::Cms::Page do
    site
    layout
    parent { create(:page) }
    label 'Child Page'
    slug 'child-page'
    full_path '/child-page'
    children_count 0
    content_cache %(
      layout_content_a

      layout_content_b
      default_snippet_content
      layout_content_c
    )
  end
end
