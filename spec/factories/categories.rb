FactoryGirl.define do
  factory :category, class: Comfy::Cms::Category do
    site_id 1
    sequence(:label) {|n| "default-#{n}"}
    categorized_type Comfy::Cms::Page
  end
end
