class Sponsor < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name

  validates :name, :email, presence: true
  validates_uniqueness_of :name, scope: :email

  scope :active, -> { where.not(activated_at: nil) }
end