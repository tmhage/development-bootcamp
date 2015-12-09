class AddSpringestIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :springest_id, :integer
    add_index :reviews, :springest_id
  end
end
