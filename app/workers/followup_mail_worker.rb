class FollowupMailWorker < MailWorker

  sidekiq_options queue: :medium_high

  self.template_name = 'Order Payment Followup'
  self.template_slug = 'order-payment-followup'

  def perform(order_id)
    @order = Order.find(order_id)
    return if order.paid?
    send_followup!
  end

  def send_followup!
    message = {
      auto_text: true,
      merge: true,
      merge_language: 'handlebars',
      subject: "#{@order.billing_name}, your order is not paid yet",
      from_name: "Development Bootcamp",
      from_email: "support@developmentbootcamp.nl"
      html: template['html'],
      merge_vars: [{
       'rcpt' => @order.billing_email,
       'vars' => [
          { name: 'name', content: @order.billing_name, },
          { name: 'payment_link', content: "https://www.developmentbootcamp.nl/tickets/#{@order.identifier}", },
          { name: 'order_date', content: @order.created_at, }
       ]
      }],
      to: [
        {
          email: @order.billing_email,
          name: @order.billing_name
        }
      ],
    }
    Rails.logger.info mandril.messages.send(message)
  end

  def mandrill
    @mandrill ||= Mandrill::API.new
  end
end
