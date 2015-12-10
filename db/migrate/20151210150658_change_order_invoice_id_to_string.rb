class ChangeOrderInvoiceIdToString < ActiveRecord::Migration
  def change
    change_column :orders, :invoice_id, :string
  end
end
