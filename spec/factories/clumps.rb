FactoryBot.define do
  factory :clump do
    name_en { Faker::Lorem.sentence }
    name_cy { Faker::Lorem.sentence }
    description_en { Faker::Lorem.paragraph }
    description_cy { Faker::Lorem.paragraph }
  end
end
