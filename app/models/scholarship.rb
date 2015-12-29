class Scholarship < ActiveRecord::Base
  include Notable

  STATI = [
    'new',
    'unsure',
    'planning interview',
    'interview planned',
    'send assignment',
    'doing assignment',
    'send contract',
    'contract sent',
    'signed',
    'to be rejected',
    'rejected',
    'cancelled'
  ]

  GENDERS = %w(male female)
  EMPLOYMENT_STATI = %w(unemployed fulltime parttime entrepeneur)

  validates_presence_of :first_name, :last_name, :email, :phone, :gender,
    :birth_date, :education_level, :employment_status, :reason,
    :future_plans, :coding_experience

  #validates_inclusion_of :full_program, :traineeship, in: [true]

  validates_inclusion_of :gender, in: GENDERS
  validates_inclusion_of :status, in: STATI
  validates_inclusion_of :employment_status, in: EMPLOYMENT_STATI

  belongs_to :bootcamp

  def self.by_status
    select("
      scholarships.*,
      CASE WHEN scholarships.status = 'new' THEN 99
      WHEN scholarships.status = 'send assignment' THEN 98
      WHEN scholarships.status = 'to be rejected' THEN 97
      WHEN scholarships.status = 'send contract' THEN 96
      WHEN scholarships.status = 'planning interview' THEN 15
      WHEN scholarships.status = 'interview planned' THEN 13
      WHEN scholarships.status = 'doing assignment' THEN 12
      WHEN scholarships.status = 'contract sent' THEN 10
      WHEN scholarships.status = 'signed' THEN 9
      WHEN scholarships.status = 'unsure' THEN 3
      WHEN scholarships.status = 'rejected' THEN 1
      WHEN scholarships.status = 'declined' THEN 1
      WHEN scholarships.status = 'cancelled' THEN 0
      END AS status_code").order("status_code DESC, created_at ASC")
  end
end
