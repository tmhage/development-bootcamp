class Lesson < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title

  belongs_to :workshop

  mount_uploader :image, LogoUploader

  validates :title, :description, presence: true
end
