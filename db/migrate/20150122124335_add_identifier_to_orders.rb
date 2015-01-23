class AddIdentifierToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :identifier, :uuid
  end
end
