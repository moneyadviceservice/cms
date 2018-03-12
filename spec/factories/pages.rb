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

    factory :english_article do
      site { create :site, label: 'en' }
      layout { create :layout, identifier: 'article' }
    end

    factory :welsh_article do
      site { create :site, :welsh }
      layout { create :layout, identifier: 'article' }
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

    factory :insight_page_about_debt do
      site { create :site, identifier: 'test-documents'}
      label 'Debt, stress and pay levels'
      after(:create) do |page|
        create :block, :debt_content, identifier: 'content', blockable: page
      end
    end

    factory :insight_page_about_pensions do
      site { create :site, identifier: 'test-documents'}
      after(:create) do |page|
        create :block, :pension_content, identifier: 'content', blockable: page
      end
    end

    factory :insight_page_about_financial_wellbeing do
      site { create :site, identifier: 'test-documents'}
      after(:create) do |page|
        create :block, :financial_wellbeing_content, identifier: 'content', blockable: page
      end
    end

    factory :insight_page_about_annuity do
      site { create :site, identifier: 'test-documents'}
      after(:create) do |page|
        create :block, :annuity_content, blockable: page
      end
    end

    factory :insight_page_titled_annuity do
      site { create :site, identifier: 'test-documents'}
      label 'annuity'
      after(:create) do |page|
        create :block, identifier: 'content', blockable: page
      end
    end

    factory :insight_page_titled_annuity2 do
      site { create :site, identifier: 'test-documents'}
      label 'Page about annuity stuff'
      after(:create) do |page|
        create :block, identifier: 'content', blockable: page
      end
    end

    factory :insight_page_with_lotsa_blocks do
      site { create :site, identifier: 'test-documents'}
      label 'Redundancy overview'
      after(:create) do |page|
        create :block, :redundancy_overview, blockable: page
        create :block, :redundancy_content, blockable: page
        create :block, :redundancy_topic, blockable: page
      end
    end

    factory :insight_page_with_raw_cta_text_block do
      site { create :site, identifier: 'test-documents'}
      label 'Page with block other than content or identifier'
      after(:create) do |page|
        create :block, :raw_cta_text_content, blockable: page
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
