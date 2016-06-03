class Review < ActiveRecord::Base
  include KpiSeries
  mount_uploader :avatar, ReviewAvatarUploader

  belongs_to :student
  belongs_to :bootcamp

  def self.published
    where("avatar IS NOT NULL AND avatar <> ''")
  end
end
