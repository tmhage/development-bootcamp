FactoryGirl.define do
  factory :sponsor do
    sequence(:name) { |n| "Sponsor name #{n}" }
    sequence(:email) { |n| "some#{n}@sponsor.com" }
    sequence(:description) { Faker::Lorem.paragraph(6) }
    hiring false

    trait :active do
      activated_at Time.now
    end
  end
end
