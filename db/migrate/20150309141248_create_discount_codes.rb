class CreateDiscountCodes < ActiveRecord::Migration
  def change
    create_table :discount_codes do |t|
      t.string :code
      t.integer :discount_percentage
      t.string :slug
      t.datetime :valid_until

      t.timestamps
    end
    add_index :discount_codes, :slug
  end
end
