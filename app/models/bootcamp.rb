class Bootcamp < ActiveRecord::Base
  attr_accessor :unpublish

  validates_presence_of :name, :level, :starts_at, :ends_at

  before_validation :set_unpublished, if: :should_unpublish?

  def self.published
    where(
      'published_at IS NOT NULL AND starts_at >= ? AND published_at <= ?',
      Date.today, Date.today
    )
  end

  def self.recent
    order(starts_at: :asc)
  end

  def name_with_dates
    "#{name} - From #{starts_at.strftime("%b %d")} to #{ends_at.strftime("%b %d")}, #{ends_at.year}"
  end

  def level_name
    _level = LevelCollection.find(level)
    return "not set" if _level.blank?
    _level.name
  end

  def published?
    !unpublished?
  end

  def unpublished?
    published_at.nil? || published_at > Date.today
  end

  def publish!
    return true if published?
    update(published_at: Date.today)
  end

  def unpublish!
    return true if unpublished?
    update(published_at: nil)
  end

  def ticket_prices
    if id == 1 || Rails.env.test?
      {
          community: community_price,
          normal: normal_price,
          supporter: supporter_price,
      }
    else
      {
        normal: normal_price
      }
    end
  end

  def community_price
    read_attribute(:community_price) || 999
  end

  def normal_price
    read_attribute(:normal_price) || 1099
  end

  def supporter_price
    read_attribute(:supporter_price) || 1199
  end

  private

  def set_unpublished
    self.published_at = nil
  end

  def should_unpublish?
    unpublish.to_i > 0
  end
end
