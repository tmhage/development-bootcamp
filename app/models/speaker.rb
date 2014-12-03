class Speaker < ActiveRecord::Base
  include Tweetable
  include Gravtastic
  gravtastic

  validates_presence_of :first_name, :last_name, :email
  validates_uniqueness_of :email

  scope :active, -> { where.not(activated_at: nil) }
end
