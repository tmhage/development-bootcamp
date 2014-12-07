class Workshop < ActiveRecord::Base
  validates :title, :description, presence: true
end
