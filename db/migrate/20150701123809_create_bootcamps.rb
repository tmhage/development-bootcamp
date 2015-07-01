class CreateBootcamps < ActiveRecord::Migration
  def change
    create_table :bootcamps do |t|
      t.string :name
      t.string :location
      t.date :starts_at
      t.date :ends_at
      t.integer :level
      t.integer :community_price
      t.integer :normal_price
      t.integer :supporter_price

      t.timestamps
    end
  end
end
