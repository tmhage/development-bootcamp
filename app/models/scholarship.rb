class Scholarship < ActiveRecord::Base
  STATI = %w(new unsure pending interview approved signed rejected cancelled)
  GENDERS = %w(male female)
  EMPLOYMENT_STATI = %w(unemployed fulltime parttime entrepeneur)

  validates_presence_of :first_name, :last_name, :email, :phone, :gender,
    :birth_date, :education_level, :employment_status, :reason,
    :future_plans

  #validates_inclusion_of :full_program, :traineeship, in: [true]

  validates_inclusion_of :gender, in: GENDERS
  validates_inclusion_of :status, in: STATI
  validates_inclusion_of :employment_status, in: EMPLOYMENT_STATI

  belongs_to :bootcamp

  def self.by_status
    select("
      scholarships.*,
      CASE WHEN scholarships.status = 'new' THEN 99
      WHEN scholarships.status = 'unsure' THEN 98
      WHEN scholarships.status = 'pending' THEN 16
      WHEN scholarships.status = 'interview' THEN 14
      WHEN scholarships.status = 'approved' THEN 11
      WHEN scholarships.status = 'signed' THEN 10
      WHEN scholarships.status = 'rejected' THEN 1
      WHEN scholarships.status = 'declined' THEN 1
      WHEN scholarships.status = 'cancelled' THEN 0
      END AS status_code").order("status_code DESC, created_at ASC")
  end
end
