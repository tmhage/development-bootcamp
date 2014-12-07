class Workshop < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title

  validates :title, :description, presence: true
end
