FactoryGirl.define do
  factory :site, class: Comfy::Cms::Site do
    label      'Default Site'
    sequence(:identifier) { |i| "identifier-#{i}" }
    hostname    'test.host'
    is_mirrored false
  end
end