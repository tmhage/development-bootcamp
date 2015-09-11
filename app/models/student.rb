class Student < ActiveRecord::Base
  include Tweetable
  include Gravtastic
  gravtastic

  belongs_to :order
  has_many :discount_codes

  before_validation :create_identifier
  after_save :ensure_discount_code

  validates_presence_of :first_name, :last_name, :email, :phone_number,
    :birth_date, if: ->{ order.blank? || order.at_step_or_after('students-#{order.students.size -1}')}

  def full_name
    "#{first_name} #{last_name}"
  end

  def create_identifier
    return unless self.identifier.blank? # Don't overwrite existing identifiers
    self.identifier = SecureRandom.uuid
    create_identifier if Student.where('students.id <> ?', self.id).
      where(identifier: self.identifier).count > 0
  end

  def current_discount_code
    self.discount_codes.valid.first ||
      (reset_discount_code! && current_discount_code)
  end

  def reset_discount_code!
    self.discount_codes.invalidate!
    self.discount_codes << create_personal_promo_code!
  end

  private

  def ensure_discount_code
    return if discount_codes.valid.count > 0
    self.discount_codes << create_personal_promo_code!
  end

  def create_personal_promo_code!
    DiscountCode.create(
      code: personal_promo_code,
      discount_percentage: 10,
      valid_until: Time.now + 1.year,
      student: self
    )
  end

  def personal_promo_code
    loop do
      promo_code = Devise.friendly_token
      break promo_code unless DiscountCode.where(code: promo_code).count > 0
    end
  end
end
