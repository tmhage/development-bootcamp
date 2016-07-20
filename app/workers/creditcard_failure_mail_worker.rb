class CreditcardFailureMailWorker < MailWorker
  include Sidekiq::Worker

  sidekiq_options queue: :high

  def perform(order_id)
    @order = Order.find(order_id)
    return if @order.paid?

    @template_name = 'Creditcard Failure'
    @template_slug = 'creditcard-failure'

    send_email!
  end

  def send_email!
    @order.create_invoice!
    message = {
      auto_text: true,
      merge: true,
      merge_language: 'handlebars',
      subject: "Your Creditcard Payment Failed",
      from_name: "Development Bootcamp",
      from_email: "support@developmentbootcamp.nl",
      html: template['html'],
      merge_vars: [{
       'rcpt' => @order.billing_email,
       'vars' => [
          { name: 'name', content: @order.billing_name, },
          { name: 'order_date', content: @order.created_at, },
          { name: 'payment_link', content: "https://www.developmentbootcamp.com/enroll/#{@order.identifier}", }
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
