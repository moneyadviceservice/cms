FactoryGirl.define do
  factory :site, class: Comfy::Cms::Site do
    label      'en'
    sequence(:identifier) { |i| "identifier-#{i}" }
    hostname    'test.host'
    is_mirrored false

    trait :welsh do
      label 'cy'
    end

    trait :with_files do
      after(:create) do |instance|
        create_list(:file, 2, site: instance)
      end
    end

    trait :with_document_files do
      after(:create) do |instance|
        create_list(:file, 2, :pdf, site: instance)
      end
    end
  end
end
