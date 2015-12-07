class CreateAdminReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :student, index: true
      t.string :avatar
      t.integer :rating
      t.references :bootcamp, index: true
      t.text :body
      t.text :url

      t.timestamps
    end
  end
end
