FactoryGirl.define do
  factory :post do
    title { Faker::Company.bs }
    content { "<p>#{Faker::Lorem.paragraphs.join("</p><p>")}</p>" }
    user
    published_at { 1.week.ago }
  end

end
