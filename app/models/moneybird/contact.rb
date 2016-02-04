class Moneybird::Contact < Moneybird::Api
  # Usage: create(firstname: 'John', lastname: 'Doe', email: 'johndoe@example.com')
  def self.create(person)
    response = execute(path: '/contacts',
      method: :post,
      payload: {
        contact: person.to_moneybird
      }
    )

    new(response)
  end

  def self.find(id)
    response = execute(path: "/contacts/#{id}",
      method: :get
    )

    new(response['contact'])
  end

  def create_invoice(order)
    ::Moneybird::Invoice.create(self.id, order)
  end
end
