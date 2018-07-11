FactoryBot.define do
  factory :user, class: Comfy::Cms::User do
    email    { Faker::Internet.email }
    name     { Faker::Name.name }
    password '12345678'
    password_confirmation { password }
    role Comfy::Cms::User.roles[:user]

    factory :admin_user do
      role Comfy::Cms::User.roles[:admin]
    end
  end
end
