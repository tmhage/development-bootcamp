module Tweetable
  extend ActiveSupport::Concern

  included do
    before_validation :clean_twitter_handle

    def clean_twitter_handle
      return if self.twitter_handle.blank?
      self.twitter_handle.sub!(/^@/, '')
    end
  end
end
