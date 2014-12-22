FactoryGirl.define do
  factory :category, class: Comfy::Cms::Category do
    site
    label 'default'
    categorized_type Comfy::Cms::Page
  end
end
