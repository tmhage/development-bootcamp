class Scholarship < ActiveRecord::Base
  include KpiSeries
  include Notable

  PRICE = 2500.0

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
    'cancelled',
    'next time',
    'in training',
    'graduated batch #1',
    'failed batch #1'
  ]

  GENDERS = %w(male female)
  EMPLOYMENT_STATI = %w(unemployed fulltime parttime entrepeneur)

  validates_presence_of :first_name, :last_name, :email, :phone, :gender,
    :birth_date, :education_level, :employment_status, :reason,
    :future_plans

  validates_presence_of :linked_in_profile_url, :coding_experience, :address, :city, :zip_code, on: :create

  validates_format_of :phone, with: /\A\+?[0-9\s\-\.x\(\)]+\z/, on: :create

  validates_inclusion_of :gender, in: GENDERS
  validates_inclusion_of :status, in: STATI
  validates_inclusion_of :employment_status, in: EMPLOYMENT_STATI

  after_save :create_moneybird_contact!, if: :status_changed?

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
      WHEN scholarships.status = 'unsure' THEN 4
      WHEN scholarships.status = 'next time' THEN 3
      WHEN scholarships.status = 'rejected' THEN 2
      WHEN scholarships.status = 'declined' THEN 1
      WHEN scholarships.status = 'cancelled' THEN 0
      WHEN scholarships.status = 'in training' THEN -1
      WHEN scholarships.status = 'graduated batch #1' THEN -2
      WHEN scholarships.status = 'failed batch #1' THEN -3
      END AS status_code").order("status_code DESC, created_at ASC")
  end

  def to_moneybird
    {
      firstname: first_name,
      lastname: last_name,
      email: email
    }
  end

  def create_moneybird_contact!
    return unless status == 'send contract'
    MoneybirdWorker.perform_async(:create_contact, :scholarship, id)
  end
end
