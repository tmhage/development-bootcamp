class AddStripePayloadToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :stripe_payload, :json
  end
end
