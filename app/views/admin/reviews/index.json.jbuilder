json.array!(@reviews) do |review|
  json.extract! review, :id, :student_id, :avatar, :rating, :bootcamp_id, :body, :url
  json.url admin_review_url(review, format: :json)
end
