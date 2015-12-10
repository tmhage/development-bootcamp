json.array!(@admin_scholarships) do |admin_scholarship|
  json.extract! admin_scholarship, :id, :first_name, :last_name, :email, :phone, :gender, :birth_date, :employment_status, :reason, :future_plans, :full_program, :traineeship, :bootcamp_id
  json.url admin_scholarship_url(admin_scholarship, format: :json)
end
