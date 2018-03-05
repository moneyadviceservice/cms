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

    trait :annuity_content do
      content { 'What does annuity mean?' }
    end
  end
end
