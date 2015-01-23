class Student < ActiveRecord::Base
  include Tweetable
  include Gravtastic
  gravtastic

  validates_presence_of :first_name, :last_name, :email,
    :birth_date, :preferred_level
end
