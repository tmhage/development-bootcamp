class InvoiceMailWorker < MailWorker

  sidekiq_options queue: :high

  def perform(order_id)
    @template_name = 'Tickets Invoice'
    @template_slug = 'tickets-invoice'

    @order = Order.find(order_id)
    send_invoice!
  end

  def send_invoice!
    @order.create_invoice!
    message = {
      auto_text: true,
      merge: true,
      merge_language: 'handlebars',
      subject: "Your Invoice for Development Bootcamp",
      from_name: "Development Bootcamp",
      from_email: "support@developmentbootcamp.nl",
      html: template['html'],
      merge_vars: [{
       'rcpt' => @order.billing_email,
       'vars' => [
          { name: 'name', content: @order.billing_name, },
          { name: 'invoice_url', content: @order.invoice_url, }
       ]
      }],
      to: [
        {
          email: @order.billing_email,
          name: @order.billing_name
        }
      ],
    }
    Rails.logger.info mandrill.messages.send(message)
  end
end
