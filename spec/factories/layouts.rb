FactoryGirl.define do
  factory :layout, class: Comfy::Cms::Layout do
    site
    label 'Default Layout'
    sequence(:identifier) { |i| "identifier-#{i}" }
    content %(
      {{cms:field:default_field_text:text}}
      layout_content_a
      {{cms:page:default_page_text:text}}
      layout_content_b
      {{cms:snippet:default}}
      layout_content_c
    )
    css 'default_css'
    js 'default_js'
    position 0

    trait :article do
      identifier 'article'
    end

    trait :video do
      identifier 'video'
    end

    trait :corporate do
      identifier 'corporate'
    end

    trait :news do
      identifier 'news'
    end

    trait :action_plan do
      identifier 'action_plan'
    end

    trait :universal_credit do
      identifier 'universal_credit'
    end

    trait :home_page do
      identifier 'home_page'
    end

    trait :footer do
      identifier 'footer'
    end

    trait :nested do
      label 'Nested Layout'
      identifier 'nested'
      content %(
        {{cms:page:header}}
        {{cms:page:content}}
      )
    end
  end
end
