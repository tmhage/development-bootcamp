class Scholarship < ActiveRecord::Base
  STATI = %w(new pending approved declined)
  GENDERS = {
    1 => :male,
    2 => :female
  }

  EMPLOYMENT_STATI = %w(unemployed fulltime parttime)

  belongs_to :bootcamp
end
