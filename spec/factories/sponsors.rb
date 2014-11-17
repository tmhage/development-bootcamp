FactoryGirl.define do
  factory :sponsor do
    sequence(:name) { |n| "Sponsor name #{n}" }
    sequence(:email) { |n| "some#{n}@sponsor.com" }
    description { Faker::Lorem.paragraph(6) }
    remarks { Faker::Lorem.paragraph(4) }
    hiring false

    logo { fixture_file_upload(Rails.root.join('app', 'assets', 'images',
      'default-logo.jpg'), 'image/jpg') }

    trait :active do
      activated_at Time.now
    end
  end
end
