class Moneybird::Invoice < Moneybird::Api
  def self.create(contact_id, order)
    options = {}

    options[:details_attributes] = rows(order)

    options[:description] = "*PLEASE NOTE*: This invoice is already paid via #{order.payment_method} and is just for your records." if order.paid?

    response = execute(path: '/invoices',
      method: :post,
      payload: {
        invoice: options.merge(contact_id: contact_id, prices_are_incl_tax: true)
      }
    )

    invoice = new(response['invoice'])

    execute(path: "/invoices/#{invoice.id}/send_invoice",
      method: :put,
      payload: {
        invoice: { send_method: 'hand' }
      }
    )

    find(invoice.id)
  end

  def self.rows(order)
    rows = {}
    order.cart.each do |ticket, amount|
      next false unless amount.present?

      rows[rows.size.to_s] = row(
        amount: "#{amount}x",
        description: "Development Bootcamp #{ticket.humanize} Ticket",
        price: order.ticket_prices[ticket.to_sym]
      )
    end

    if order.paid_by_creditcard?
      rows[rows.size.to_s] = row(
        description: "Creditcard payment fee",
        price: order.creditcard_fee
      )
    end

    if order.cart_discount > 0
      rows[rows.size.to_s] = row(
        description: "Discount #{order.discount_code.discount_percentage}% on non-community tickets",
        price: -(order.cart_discount)
      )
    end

    rows
  end

  def self.row(options = {})
    row_defaults = {
      amount: "1x", tax_rate_id: 562244
    }

    row_defaults.merge(options)
  end

  def self.find(id)
    response = execute(path: "/invoices/#{id}",
      method: :get
    )

    new(response['invoice'])
  end

  def mark_paid!(paid_amount, payment_method, date)
    puts id
    puts({
      payload: {
        payments: [
          {
            payment_date: date.strftime("%Y-%m-%d"),
            payment_method: payment_method.downcase,
            price: paid_amount,
            send_email: false
          }
        ]
      }
    })
    execute(path: "api/v1.0/invoices/#{id}/payments",
      method: :post,
      payload: {
        payment: {
          payment_date: date.strftime("%Y-%m-%d"),
          payment_method: payment_method.downcase,
          price: paid_amount.round(2),
          send_email: false
        }
      }
    )
    self.class.find(id)
  end
end
