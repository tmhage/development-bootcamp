class CreditcardChargerWorker
  include Sidekiq::Worker

  def perform(order_id)
    @order = Order.find(order_id)
    return if @order.paid? || @order.stripe_token.blank?
    @order.charge_creditcard!
    @order.update(paid_by_creditcard: true)
    send_invoice_and_tickets!
  end

  def send_invoice_and_tickets!
    InvoiceMailWorker.perform_async(@order.id)
    TicketMailWorker.perform_async(@order.id)
  end
end
