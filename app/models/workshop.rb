class Workshop < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title

  has_many :lessons

  validates :title, :description, presence: true
end
