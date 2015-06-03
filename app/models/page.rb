class Page < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title, use: :slugged
  validates_presence_of :title, :body

  def self.published
    where(published: true)
  end

  def unpublished?
    !published?
  end

  def publish!
    update(published: true)
  end

  def unpublish!
    update(published: false)
  end
end
