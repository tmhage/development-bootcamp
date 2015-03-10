FactoryGirl.define do
  factory :discount_code do
    code { Faker::Company.name }
    discount_percentage { 10 }
    valid_until { Time.now + 1.month }
  end
end
