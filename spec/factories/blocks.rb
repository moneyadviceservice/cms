FactoryGirl.define do
  factory :block, class: Comfy::Cms::Block do
    identifier { 'content' }
    content { 'financial' }
    association :blockable, factory: :page

    trait :debt_content do
      identifier { 'content' }
      content { 'debt' }
    end

    trait :pension_content do
      identifier { 'content' }
      content { 'pension' }
    end

    trait :financial_wellbeing_content do
      identifier { 'content' }
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

    trait :redundancy_content do
      identifier { 'content' }
      content { 'redundancy content' }
    end

    trait :redundancy_topic do
      identifier { 'topic' }
      content { 'redundancy topic' }
    end

    trait :raw_cta_text_content do
      identifier { 'raw_cta_text' }
      content { 'random content' }
    end

    trait :working_age_client_group do
      identifier { 'client_groups' }
      content { 'Working age (18 - 65)' }
    end

    trait :young_adults_client_group do
      identifier { 'client_groups' }
      content { 'Young adults (17 - 24)' }
    end

    trait :saving_topic do
      identifier { 'topic' }
      content { 'Saving' }
    end

    trait :published_by_uk do
      identifier { 'countries_of_delivery' }
      content { 'United Kingdom' }
    end

    trait :order_by_date do
      identifier { 'order_by_date' }
      content { '2017-03-15' }
    end
  end
end
