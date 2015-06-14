class Moneybird::Invoice < Moneybird::Api
  # Usage: create(firstname: 'John', lastname: 'Doe', email: 'johndoe@example.com')
  def self.create(contact_id, order)
    options = {}
    count = 0
    rows = {}
    order.cart.each do |ticket, amount|
      next false unless amount.present?

      rows[count.to_s] = {
        amount: "#{amount}x",
        description: "Development Bootcamp #{ticket.humanize} Ticket",
        price: order.ticket_prices[ticket.to_sym],
        tax_rate_id:  562244,
        row_order: count
      }

      count += 1
    end

    options[:details_attributes] = rows

    puts options

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

  def self.find(id)
    response = execute(path: "/invoices/#{id}",
      method: :get
    )

    new(response['invoice'])
  end

  def add_row(row)
    row[:detail][:invoice_id] = id
    options = {
      details_attributes: [ row ]
    }

    puts options

    execute(path: "/invoices/#{id}",
      method: :put,
      payload: {
        invoice: options
      }
    )
  end
end
