FactoryGirl.define do
  factory :categorization, class: Comfy::Cms::Categorization do
    sequence(:categorized_id) {|n| n }
    sequence(:category_id) {|n| n }
    categorized_type "Page"
  end
end
