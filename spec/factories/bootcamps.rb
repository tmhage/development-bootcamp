FactoryGirl.define do
  factory :bootcamp do
    level { 1 }
    name { Faker::Name.name }
    location { Faker::Address.city }
    starts_at { Date.today + 14.days }
    ends_at { Date.today + 21.days }
    community_price { 699 }
    normal_price { 1499 }
    supporter_price { 1999 }
  end
end
