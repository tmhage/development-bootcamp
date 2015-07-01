class AddBootcampToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :bootcamp_id, :integer
    add_index :orders, :bootcamp_id
  end
end
