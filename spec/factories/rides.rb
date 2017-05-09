FactoryGirl.define do
  factory :ride do
    association :driver, factory: :user
    association :passenger, factory: :user
    route
  end
end
