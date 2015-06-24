class Student < ActiveRecord::Base
  include Tweetable
  include Gravtastic
  gravtastic

  belongs_to :order

  before_validation :create_identifier

  validates_presence_of :first_name, :last_name, :email,
    :birth_date, :preferred_level, if: ->{ order.blank? || order.at_step_or_after('students-#{order.students.size -1}')}

  def full_name
    "#{first_name} #{last_name}"
  end

  def create_identifier
    return unless self.identifier.blank? # Don't overwrite existing identifiers
    self.identifier = SecureRandom.uuid
    create_identifier if Student.where('students.id <> ?', self.id).
      where(identifier: self.identifier).count > 0
  end
end
