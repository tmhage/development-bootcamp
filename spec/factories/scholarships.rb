FactoryGirl.define do
  factory(:scholarship) do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    gender { Scholarship::GENDERS.sample }
    birth_date { 18.years.ago }
    education_level { 'WO' }
    employment_status { Scholarship::EMPLOYMENT_STATI.sample }
    reason { Faker::Lorem.paragraph }
    future_plans { Faker::Lorem.paragraph }
    status { 'new' }
    bootcamp
    coding_experience { CodeExperienceCollection.all.map(&:id).sample(3) }
    linked_in_profile_url { Faker::Internet.url }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    zip_code { Faker::Address.zip_code }
  end
end
