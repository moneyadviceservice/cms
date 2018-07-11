FactoryBot.define do
  factory :category, class: Comfy::Cms::Category do
    site_id 1
    sequence(:label) { |n| "default-#{n}" }
    sequence(:title_en) { |n| "default-title-en-#{n}" }
    sequence(:title_cy) { |n| "default-title-cy-#{n}" }
    categorized_type Comfy::Cms::Page
  end
end
