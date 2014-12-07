FactoryGirl.define do
  factory :lesson do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(3) }
    published false
    starts_at { Faker::Date.forward(400) }
    duration 100
    icon 'book'
    trait :workshop do
      workshop
    end
  end
end
