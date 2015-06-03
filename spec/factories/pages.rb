FactoryGirl.define do
  factory :page do
    title { Faker::Company.bs }
    body { "<p>#{Faker::Lorem.paragraphs.join("</p><p>")}</p>" }
    published true
  end
end
