FactoryGirl.define do
  factory :user, class: Comfy::Cms::User do
    email    { Faker::Internet.email }
    name     { Faker::Name.name }
    password '12345678'
    password_confirmation '12345678'
    role 'admin'
  end
end
