class Moneybird::Invoice < Moneybird::Api
  def self.create(contact_id, order)
    options = {}

    options[:details_attributes] = rows(order)

    options[:description] = "*PLEASE NOTE*: This invoice is already paid via #{order.payment_method} and is just for your records." if order.paid?

    payload = {
      sales_invoice: options.merge(
        contact_id: contact_id,
        prices_are_incl_tax: true,
        document_style_id: '137438981859051050',
        workflow_id: '137438981703861781',
      )
    }

    puts payload

    response = execute(path: '/sales_invoices',
      method: :post,
      payload: payload
    )

    invoice = new(response)

    execute(path: "/sales_invoices/#{invoice.id}/send_invoice",
      method: :put,
      payload: {
        sales_invoice: { send_method: 'hand' }
      }
    )

    find(invoice.id)
  end

  def self.rows(order)
    rows = {}
    order.cart.each do |ticket, amount|
      next false unless amount.present?

      rows[rows.size.to_s] = row(
        amount: "#{amount} x",
        description: "Ticket for #{order.bootcamp.name_with_dates}",
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
        description: "#{order.discount_code.code} (#{order.discount_code.discount_percentage}%)",
        price: -(order.cart_discount)
      )
    end

    rows
  end

  def self.row(options = {})
    row_defaults = {
      amount: "1 x", tax_rate_id: "137438981644092939"
    }

    row_defaults.merge(options)
  end

  def self.find(id)
    response = execute(path: "/sales_invoices/#{id}",
      method: :get
    )

    new(response)
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
    execute(path: "api/v2/sales_invoices/#{id}/register_payment",
      method: :post,
      payload: {
        payment: {
          payment_date: Time.now.iso8601,
          payment_method: payment_method.downcase,
          price: paid_amount.to_f.round(2),
          send_email: false
        }
      }
    )
    self.class.find(id)
  end
end
