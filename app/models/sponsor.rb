class Sponsor < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  mount_uploader :logo, LogoUploader

  validates :name, :email, :first_name, :last_name, presence: true
  validates_uniqueness_of :name, scope: :email

  scope :active, -> { where.not(activated_at: nil) }

  def self.plans
    {
      platinum: {
        name: 'Platinum',
        price: 6000
      },
      gold: {
        name: 'Gold',
        price: 3600
      },
      silver: {
        name: 'Silver',
        price: 1000
      },
      party: {
        name: 'Party Support',
        price: 2500
      },
      dinner: {
        name: 'Dinner Support',
        price: 2500
      },
      hackathon: {
        name: 'Hackathon Support',
        price: 4000
      }
    }
  end
end
