class AddDiscountCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :discount_code_id, :integer
    add_index :orders, :discount_code_id
  end
end
