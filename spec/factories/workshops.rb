FactoryGirl.define do
  factory :workshop, class: 'Workshop' do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph(4) }
    prerequisite { Faker::Lorem.paragraph(4) }
    outcome { Faker::Lorem.paragraph(4) }
    published false
    starts_at { Faker::Date.forward(400) }
  end
end
