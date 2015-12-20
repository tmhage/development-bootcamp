class OpenDay < ActiveRecord::Base
  geocoded_by :address

  validates_presence_of :address, :starts_at, :facebook_event_url,
                        :description_en, :description_nl

  after_validation :geocode, if: ->(obj){ obj.address.present? && obj.address_changed? }

  def self.upcoming
    where('starts_at > ?', Date.today.beginning_of_day).
      order(starts_at: :asc)
  end
end
