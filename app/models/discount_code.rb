class DiscountCode < ActiveRecord::Base
  has_many :orders
  belongs_to :student

  before_validation :generate_slug!

  def self.valid
    where(self.arel_table[:valid_until].gteq('NOW()'))
  end

  def self.invalidate!
    update_all(valid_until: Time.now - 1.day)
  end

  def generate_slug!
    return if code.blank? || slug.present?
    self.slug = code.parameterize
  end

  def track_click!
    update(clicks: clicks.to_i + 1)
  end
end
