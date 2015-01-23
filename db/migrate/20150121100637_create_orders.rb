class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal :price
      t.datetime :payed_at
      t.string :mollie_payment_id
      t.string :refunded_at
      t.string :mollie_refund_id

      t.timestamps
    end
  end
end
