class Bootcamp < ActiveRecord::Base
  validates_presence_of :name, :level, :starts_at, :ends_at
  def name_with_dates
    "#{name} - From #{starts_at.strftime("%b %d")} to #{ends_at.strftime("%b %d")}"
  end

  def level_name
    _level = LevelCollection.find(level)
    return "not set" if _level.blank?
    _level.name
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
end
