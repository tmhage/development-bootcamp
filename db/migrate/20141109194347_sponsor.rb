class Sponsor < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.string :website
      t.string :logo
      t.boolean :hiring
      t.string :email
      t.text :remarks
      t.datetime :activated_at

      t.timestamps
    end
  end
end
