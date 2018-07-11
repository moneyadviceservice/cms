FactoryBot.define do
  factory :page_feedback do
    page
    liked true
    session_id '5trefg13dw'
    comment 'Awesome!'
    shared_on 'Facebook'
  end
end
