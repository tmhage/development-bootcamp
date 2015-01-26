class AddManuallyPaidToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :manually_paid, :boolean
  end
end
