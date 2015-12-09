class AddSpringestAuthorToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :springest_author, :string
  end
end
