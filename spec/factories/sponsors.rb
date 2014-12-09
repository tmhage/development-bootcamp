FactoryGirl.define do
  factory :sponsor do
    sequence(:name) { |n| "Sponsor name #{n}" }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "some#{n}@sponsor.com" }
    description { Faker::Lorem.paragraph(4) }
    remarks { Faker::Lorem.paragraph(4) }
    website 'imagine_website_url'
    hiring false

    logo { fixture_file_upload(Rails.root.join('app', 'assets', 'images',
      'default-logo.png'), 'image/png') }

    trait :active do
      activated_at Time.now
    end
  end
end
