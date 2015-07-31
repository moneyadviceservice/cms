FactoryGirl.define do
  factory :redirect, class: Redirect do
    source '/en/foo'
    destination '/en/bar'
    redirect_type 'temporary'
  end
end
