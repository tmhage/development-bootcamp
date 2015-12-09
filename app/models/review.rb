class Review < ActiveRecord::Base
  belongs_to :student
  belongs_to :bootcamp

  def self.published
    where("avatar IS NOT NULL AND avatar <> ''")
  end
end
