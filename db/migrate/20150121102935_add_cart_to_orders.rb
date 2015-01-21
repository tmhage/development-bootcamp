class AddCartToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cart, :json
  end
end
