FactoryBot.define do
  factory :block, class: Comfy::Cms::Block do
    identifier { 'content' }
    content { 'some block content' }
    association :blockable, factory: :page
  end
end
