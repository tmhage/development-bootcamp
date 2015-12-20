FactoryGirl.define do
  factory(:open_day) do
    starts_at { Faker::Date.forward(23) }
    address { "#{Faker::Address.street_address}, #{Faker::Address.zip_code} #{Faker::Address.city}" }
    description_en { Faker::Lorem.paragraph(2) }
    description_nl { Faker::Lorem.paragraph(2) }
    facebook_event_url { Faker::Internet.url('facebook.com') }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
