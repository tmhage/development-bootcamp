class AddLanguageToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :language, :string
    add_column :reviews, :original_date, :datetime
    remove_column :reviews, :url
  end
end
