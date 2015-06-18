class AddPaidByIdealToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :paid_by_ideal, :bool, default: false
  end
end
