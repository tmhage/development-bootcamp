FactoryGirl.define do
  factory :speaker do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    twitter_handle { Faker::Internet.user_name }
    description { Faker::Lorem.paragraph(4) }
    remarks { Faker::Lorem.paragraph(4) }
    website { Faker::Internet.url('example.com') }

    trait :active do
      activated_at Time.now
    end
  end
end
