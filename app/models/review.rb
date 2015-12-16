class Review < ActiveRecord::Base
  mount_uploader :avatar, ReviewAvatarUploader

  belongs_to :student
  belongs_to :bootcamp

  def self.published
    where("avatar IS NOT NULL AND avatar <> ''")
  end
end
