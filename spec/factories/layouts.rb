FactoryGirl.define do
  factory :layout, class: Comfy::Cms::Layout do
    site
    label 'Default Layout'
    sequence(:identifier) { |i| "identifier-#{i}" }
    content %{
      {{cms:field:default_field_text:text}}
      layout_content_a
      {{cms:page:default_page_text:text}}
      layout_content_b
      {{cms:snippet:default}}
      layout_content_c
    }
    css 'default_css'
    js 'default_js'
    position 0

    trait :nested do
      label      'Nested Layout'
      identifier 'nested'
      content %{
        {{cms:page:header}}
        {{cms:page:content}}
      }
    end
  end
end