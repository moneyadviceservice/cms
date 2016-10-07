FactoryGirl.define do
  factory :page_feedback do
    page_id 1
    liked true
    comment 'Awesome!'
    shared_on 'Facebook'
  end
end
