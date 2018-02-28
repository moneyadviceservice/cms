FactoryGirl.define do
  factory :block, class: Comfy::Cms::Block do
    identifier { 'content' }
    content { 'financial' }
    association :blockable, factory: :page

    trait :debt_content do
      content { 'debt' }
    end

    trait :pension_content do
      content { 'pension' }
    end

    trait :financial_wellbeing_content do
      content { 'Financial well being: the employee view' }
    end
  end
end
