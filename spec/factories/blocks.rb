FactoryGirl.define do
  factory :block, class: Comfy::Cms::Block do
    identifier { 'content' }
    content { 'some debt content' }
    association :blockable, factory: :page
  end
end
