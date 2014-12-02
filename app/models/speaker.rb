class Speaker < ActiveRecord::Base
  include Gravtastic
  gravtastic

  before_validation :clean_twitter_handle
  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email

  scope :active, -> { where.not(activated_at: nil) }

  def clean_twitter_handle
    return if self.twitter_handle.blank?
    self.twitter_handle.sub!(/^@/, '')
  end
end
