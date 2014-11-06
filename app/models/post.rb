class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title

  belongs_to :user

  validates_presence_of :title, :content

  def self.published
    where(
      "published_at < ? AND ( unpublished_at IS NULL OR unpublished_at > ? )",
      DateTime.now, DateTime.now)
  end

  def self.unpublished
    where(
      "published_at > ? OR unpublished_at < ? OR published_at IS NULL",
      DateTime.now, DateTime.now)
  end

  def self.recent
    order("published_at desc")
  end

  def publish!
    update_attribute :published_at, DateTime.now
  end

  def unpublish!
    update_attribute :unpublished_at, DateTime.now
  end
end
