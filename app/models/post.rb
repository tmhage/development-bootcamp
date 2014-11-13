class Post < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged

  mount_uploader :cover_image, CoverImageUploader

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
    update published_at: DateTime.now, unpublished_at: nil
  end

  def unpublish!
    update_attribute :unpublished_at, DateTime.now
  end

  def published?
    (published_at && published_at < DateTime.now) &&
      (unpublished_at.blank? || unpublished_at > DateTime.now)
  end

  def to_be_published?
    published_at && published_at > DateTime.now
  end

  def to_be_unpublished?
    published? && unpublished_at && unpublished_at > DateTime.now
  end

  def unpublished?
     published_at.blank? || to_be_published? ||
      (unpublished_at && unpublished_at < DateTime.now)
  end
end
