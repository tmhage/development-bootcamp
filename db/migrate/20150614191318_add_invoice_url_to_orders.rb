class AddInvoiceUrlToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :invoice_url, :text
  end
end
