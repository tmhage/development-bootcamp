class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :title
      t.string :slug
      t.string :image
      t.string :icon
      t.text :description
      t.boolean :published
      t.datetime :starts_at
      t.integer :duration
      t.references :workshop

      t.timestamps
    end
  end
end
