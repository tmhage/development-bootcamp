class AddBillingCountryToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :billing_country, :string
  end
end
