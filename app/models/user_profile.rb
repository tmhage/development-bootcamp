class UserProfile < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :role
end
