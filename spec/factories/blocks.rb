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
      identifier { 'content' }
      content { 'What does annuity mean?' }
    end

    trait :redundancy_overview do
      identifier { 'overview' }
      content { 'redundancy overview' }
    end

    trait :raw_cta_text_content do
      identifier { 'raw_cta_text' }
      content { 'random content' }
    end
  end
end
