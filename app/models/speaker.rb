class Speaker < ActiveRecord::Base
  include Tweetable
  include Gravtastic
  gravtastic

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email

  scope :active, -> { where.not(activated_at: nil) }

  def self.roles
    {
      keynote_speaker: 'Keynote Speaker',
      teacher: 'Teacher (Workshops)',
      volunteer: 'Volunteer (Assisting Workshops)'
    }
  end
end
