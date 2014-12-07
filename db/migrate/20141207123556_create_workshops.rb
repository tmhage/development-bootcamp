class CreateWorkshops < ActiveRecord::Migration
  def change
    create_table :workshops do |t|
      t.string :title
      t.text :description
      t.text :prerequisite
      t.text :outcome
      t.boolean :published
      t.datetime :starts_at

      t.timestamps
    end
  end
end
