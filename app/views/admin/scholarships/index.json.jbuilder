json.array!(@scholarships) do |scholarship|
  json.extract! scholarship, :id, :first_name, :last_name, :email, :phone, :gender, :birth_date, :employment_status, :reason, :future_plans, :full_program, :traineeship, :bootcamp_id
  json.url scholarship_url(scholarship, format: :json)
end
