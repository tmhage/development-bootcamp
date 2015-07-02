class RenameOrdersPayedAtToPaidAt < ActiveRecord::Migration
  def change
    rename_column :orders, :payed_at, :paid_at
  end
end
