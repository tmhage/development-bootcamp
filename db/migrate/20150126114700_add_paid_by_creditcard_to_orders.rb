class AddPaidByCreditcardToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :paid_by_creditcard, :boolean
  end
end
