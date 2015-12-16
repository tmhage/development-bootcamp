class MigrateAvatarsToUploader < ActiveRecord::Migration
  def change
    rename_column :reviews, :avatar, :original_avatar
    add_column :reviews, :avatar, :string

    migrate_avatars
  end

  def migrate_avatars
    reviews = Review.all
    reviews.each do |review|
      original_avatar = review.original_avatar
      next if original_avatar.blank?

      # Let's use the built-in remote url support from
      # Carrierwave here.
      #
      # See: https://github.com/carrierwaveuploader/carrierwave#/uploading-files-from-a-remote-location
      review.remote_avatar_url = original_avatar
      review.save
    end
  end
end
