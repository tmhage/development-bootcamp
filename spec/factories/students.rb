FactoryGirl.define do
  factory :student do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    twitter_handle { Faker::Internet.user_name }
    remarks { Faker::Lorem.paragraph(4) }
    birth_date "2014-12-03"
    github_handle { Faker::Internet.user_name }
  end

end
