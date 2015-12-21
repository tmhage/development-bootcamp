class Scholarship < ActiveRecord::Base
  STATI = %w(new pending interview approved signed rejected cancelled)
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
end
