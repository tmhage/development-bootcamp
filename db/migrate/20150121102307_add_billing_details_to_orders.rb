class AddBillingDetailsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :billing_company_name, :string
    add_column :orders, :billing_name, :string
    add_column :orders, :billing_email, :string
    add_column :orders, :billing_address, :string
    add_column :orders, :billing_postal, :string
    add_column :orders, :billing_city, :string
    add_column :orders, :billing_phone, :string
    add_column :orders, :billing_vat_id, :string
  end
end
