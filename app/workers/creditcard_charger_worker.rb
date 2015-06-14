class CreditcardChargerWorker
  include Sidekiq::Worker

  def perform(order_id)
    @order = Order.find(order_id)
    return if @order.paid? || @order.stripe_token.blank?
    @order.charge_creditcard!
  end
end
