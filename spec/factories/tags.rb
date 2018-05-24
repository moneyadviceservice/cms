FactoryGirl.define do
  factory :tag, class: Tag do
    sequence(:value) { |n| "a-tag-#{n}" }
  end
end
