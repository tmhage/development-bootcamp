class DiscountCode < ActiveRecord::Base
  has_many :orders

  before_validation :generate_slug!

  def self.valid
    where(self.arel_table[:valid_until].gteq('NOW()'))
  end

  def generate_slug!
    return if code.blank? || slug.present?
    self.slug = code.parameterize
  end
end
