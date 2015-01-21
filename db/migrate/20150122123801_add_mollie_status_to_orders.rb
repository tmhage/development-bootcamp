class AddMollieStatusToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :mollie_status, :string
  end
end
