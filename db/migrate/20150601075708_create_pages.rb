class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :slug
      t.text :body
      t.boolean :published

      t.timestamps
    end
    add_index :pages, :slug, where: "pages.published = 't'", unique: true
  end
end
