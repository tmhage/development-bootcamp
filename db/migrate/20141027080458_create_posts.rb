class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :slug
      t.text :content
      t.text :cover_image
      t.references :user, index: true
      t.datetime :published_at
      t.datetime :unpublished_at

      t.timestamps
    end
    add_index :posts, :slug, unique: true
  end
end
