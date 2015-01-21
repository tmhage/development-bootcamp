class AddMolliePaymentMethodToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :mollie_payment_method, :string
  end
end
