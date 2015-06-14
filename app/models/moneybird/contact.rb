class Moneybird::Contact < Moneybird::Api
  # Usage: create(firstname: 'John', lastname: 'Doe', email: 'johndoe@example.com')
  def self.create(order)
    order_name = order.billing_name.split(" ")

    options = {
      firstname: order_name.shift,
      lastname: order_name.join(" "),
      email: order.billing_email,
      address1: order.billing_address,
      country: order.billing_country,
      city: order.billing_city,
      company_name: order.billing_company_name,
      zipcode: order.billing_postal
    }

    response = execute(path: '/contacts',
      method: :post,
      payload: {
        contact: options
      }
    )

    new(response['contact'])
  end

  def self.find(id)
    response = execute(path: "/contacts/#{id}",
      method: :get
    )

    new(response['invoice'])
  end

  def create_invoice(order)
    ::Moneybird::Invoice.create(id, order)
  end
end
