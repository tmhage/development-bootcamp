class HelpscoutToMailchimpWorker
  include Sidekiq::Worker

  sidekiq_options queue: :low

  def perform(customer_id)
    customer = helpscout.customer(customer_id)
    add_to_list(customer)
  end

  def add_to_list(customer)
    gb = Gibbon::API.new
    gb.lists.subscribe({
      :id => MailingLists::STUDENTS,
      email: {
        email: customer.emails.first.value
      },
      merge_vars: {
        FNAME: customer.firstName,
        LNAME: customer.lastName
      },
      double_optin: false,
      send_welcome: false
    })
  end

  def helpscout
    @helpscout ||= HelpScout::Client.new(ENV["HELPSCOUT_API_KEY"])
  end
end
