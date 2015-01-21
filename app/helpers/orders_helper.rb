module OrdersHelper
  def payment_link_to(text, order, options = {})
    # We set the host and port here because Mollie does not accept local hosts.
    payment_options = { redirectUrl: thanks_ticket_url(order, host: 'www.developmentbootcamp.nl', port: 80) }
    payment_options[:webhookUrl] = webhook_tickets_url(host: 'www.developmentbootcamp.nl', port: 80)
    payment = order.create_payment payment_options
    link_to text, payment.getPaymentUrl, options
  end

  def order_step_name(step)
    if step =~ /^students/
      nr = step.split('-').last.to_i + 1
      "Student Details #{nr}"
    elsif step == 'tickets'
      "Choose Tickets"
    elsif step == 'details'
      "Billing Information"
    elsif step == 'confirmation'
      "Confirmation"
    end
  end
end
