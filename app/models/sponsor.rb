class Sponsor < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  mount_uploader :logo, LogoUploader

  validates :name, :email, presence: true
  validates_uniqueness_of :name, scope: :email

  scope :active, -> { where.not(activated_at: nil) }

  def self.plans
    {
      platinum: {
        name: 'Platinum',
        price: 10000
      },
      gold: {
        name: 'Gold',
        price: 5000
      },
      silver: {
        name: 'Silver',
        price: 2000
      },
      party: {
        name: 'Party Support',
        price: 5000
      },
      lunch: {
        name: 'Lunch Support',
        price: 5000
      },
      hackathon: {
        name: 'Hackathon Support',
        price: 2000
      }
    }
  end
end
