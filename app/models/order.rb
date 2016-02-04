require "Mollie/API/Client"

class Order < ActiveRecord::Base
  has_paper_trail

  attr_accessor :promo_code, :validate_promo_code, :select_bootcamp

  belongs_to :discount_code
  has_many :students, inverse_of: :order

  validate :validate_cart, unless: :selecting_bootcamp?
  validate :validate_discount_code

  validates_presence_of :identifier

  validates_presence_of :bootcamp

  validates_presence_of :cart, unless: :selecting_bootcamp?

  validates_presence_of :billing_name, :billing_email, :billing_address,
                        :billing_postal, :billing_city, :billing_country,
                        :billing_phone, if: ->{ at_step_or_after('details') }

  validate :validate_students_amount, if: ->{ cart_sum_tickets > 0 && at_step_or_after("confirmation") }

  validates :terms_and_conditions, inclusion: { in: [true], message: 'must be accepted.' }, if: ->{ at_step_or_after('details') }

  accepts_nested_attributes_for :students

  belongs_to :bootcamp

  before_validation :create_identifier

  after_save :reset_discount_codes

  def to_param
    self.identifier
  end

  def to_moneybird
    order_name = billing_name.split(" ")

    {
      firstname: order_name.shift,
      lastname: order_name.join(" "),
      email: billing_email,
      address1: billing_address,
      country: billing_country,
      city: billing_city,
      company_name: billing_company_name,
      zipcode: billing_postal
    }
  end

  def current_step
    @current_step || steps.first
  end

  def current_step=(step)
    raise ArgumentError.new("Step #{step} does not exist!") unless steps.include?(step) || step.nil?
    @current_step = step
  end

  def steps
    steps = (0...cart_sum_tickets).map{ |i| "students-#{i}" }
    steps.unshift "details"
    steps.unshift "tickets"
    steps.push  "confirmation"
  end

  def next_step
    step_index = [steps.index(current_step)+1, (steps.size-1)].min
    self.current_step = steps[step_index]
  end

  def previous_step
    step_index = [steps.index(current_step)-1, 0].max
    self.current_step = steps[step_index]
  end

  def first_step?
    current_step == steps.first
  end

  def last_step?
    current_step == steps.last
  end

  def at_step_or_after(step)
    return true unless steps.include?(step)
    steps.index(current_step) >= steps.index(step)
  end

  def after_step(step)
    return true unless steps.include?(step)
    steps.index(current_step) > steps.index(step)
  end

  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end

  def validating_promo_code?
    validate_promo_code.present?
  end

  def selecting_bootcamp?
    select_bootcamp.present?
  end

  def confirmed?
    persisted? && confirmed_at.present?
  end

  def ticket_types
    ticket_prices.keys
  end

  def ticket_prices
    (bootcamp || Bootcamp.new).ticket_prices
  end

  def cart
    (super || {}).with_indifferent_access
  end

  def cart_sum_total
    ticket_total = ticket_prices.map do |type, price|
      cart[type].to_i * price
    end.inject(&:+)
    return ticket_total unless discount_code.present?
    (ticket_total - cart_discount).round(2)
  end

  def creditcard_fee
    (cart_sum_total * 0.029).round(2)
  end

  def creditcard_total
    ((cart_sum_total + creditcard_fee).round(2) * 100).to_i
  end

  def cart_discount
    percentages = student_discount_code_percentages
    discount_amounts = []

    cart.keys.each do |type|
      if type == "community" || percentages.size == 0
        discount_amounts << 0
      else
        cart[type].to_i.times do
           discount_amounts << (ticket_prices[type.to_sym] * (percentages.shift / 100.0))
        end
      end
    end

    discount_amounts.inject(0, :+)
  end

  def student_discount_code_percentages
    return [0] unless discount_code.present?
    students.map do |student|
      next [discount_code.discount_percentage] unless discount_code.student && discount_code.student.email == student.email
      multiplier = [(discount_code.orders.count - 1), 1].max
      discount_code.discount_percentage * multiplier
    end.flatten
  end

  def cart_sum_tickets
    ticket_prices.keys.map do |type|
      cart[type].to_i
    end.inject(&:+)
  end

  def validate_cart
    return if cart_valid?
    errors.add(:cart, "Please select 1 or more tickets.")
  end

  def validate_discount_code
    return if promo_code.blank?
    return if has_valid_discount_code?
    errors.add(:promo_code, "is not a valid.")
  end

  def has_valid_discount_code?
    return false if promo_code.blank?
    discount_code = DiscountCode.valid.find_by_code(promo_code)
    self.discount_code = discount_code if discount_code.present?
    discount_code.present?
  end

  def validate_students_amount
    return if students.size == cart_sum_tickets && students.map(&:valid?).all?
    errors.add(:students, "You need to provide details for all #{cart_sum_tickets} students.")
  end

  def min_ticket_price
    minimum = ticket_prices.values.min
    return minimum unless discount_code.present?
    minimum * (discount_code.discount_percentage / 100.0)
  end

  def cart_valid?
    cart_has_valid_ticket_types? &&
      cart_sum_total >= min_ticket_price &&
        cart_has_positive_amounts_for_tickets?
  end

  def cart_has_valid_ticket_types?
    return true if ((cart.keys.map(&:to_sym) - ticket_types) + (ticket_types - cart.keys.map(&:to_sym))).empty?
    return true if ((cart.select{|_,val| val.present?}.keys.map(&:to_sym) - ticket_types) + (ticket_types - cart.select{|_,val| val.present?}.keys.map(&:to_sym))).empty?
    errors.add(:cart, "You have selected an invalid ticket type. Please reload this page and try again. #{ticket_types} #{cart}")
    false
  end

  def cart_has_positive_amounts_for_tickets?
    return true if cart.values.select{|v| v.to_i >= 0 }.size == cart.values.size &&
      cart_sum_tickets > 0
    errors.add(:cart, "You can only order amounts of 1 or more tickets.")
    false
  end

  def create_identifier
    return if persisted? # Don't overwrite existing identifiers
    self.identifier = SecureRandom.uuid
    create_identifier if Order.where(identifier: self.identifier).count > 0
  end

  def create_payment(options = {})
    _payment = mollie.payments.create options.merge(
      amount: (cart_sum_total.to_f),
      description: "Development Bootcamp tuition fee",
      metadata: { identifier: self.identifier})
    update(mollie_payment_id: _payment.id)
    _payment
  end

  def payment
    return unless self.mollie_payment_id.present?
    @payment ||= mollie.payments.get(self.mollie_payment_id) rescue nil
    @payment ||= old_mollie.payments.get(self.mollie_payment_id) rescue nil
    @payment
  end

  def paid?
    return true if manually_paid? || paid_by_creditcard? || paid_by_ideal?

    if payment && payment.paid?
      store_ideal_payment_status
      return true
    end

    false
  end

  def payment_method
    return 'Creditcard' if paid_by_creditcard?
    return 'iDeal' if paid_by_ideal? || (payment && payment.paid?)
    'Manual'
  end

  def mollie
    @mollie || setup_mollie
  end

  def old_mollie
    @old_mollie || setup_old_mollie
  end

  def setup_mollie
    @mollie = Mollie::API::Client.new
    @mollie.setApiKey ENV['DB_MOLLY_KEY'] || ""
    @mollie
  end

  def setup_old_mollie
    @old_mollie = Mollie::API::Client.new
    @old_mollie.setApiKey ENV['DB_OLD_MOLLY_KEY'] || ""
    @old_mollie
  end

  def charge_creditcard!
    return false if paid? || stripe_token.blank?

    Stripe.api_key = ENV['DB_STRIPE_SKEY']

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      Stripe::Charge.create(
        :amount => creditcard_total,
        :currency => "eur",
        :source => stripe_token,
        :description => "Development Bootcamp Community Ticket"
      )
      return true
    rescue Stripe::CardError => e
      Appsignal.add_exception e
    end

    false
  end

  def create_invoice!
    return if invoiced?
    contact = Moneybird::Contact.create(self)
    invoice = contact.create_invoice(self)
    update(invoice_url: invoice.url, invoice_id: invoice.id)
  end

  def mark_invoice_paid!
    return false unless paid?
    create_invoice! unless invoiced?
    Moneybird::Invoice.find(invoice_id).mark_paid!(invoice_amount, payment_method, paid_at)
  end

  def invoiced?
    invoice_url.present?
  end

  def invoice_amount
    return creditcard_total if paid_by_creditcard?
    cart_sum_total
  end

  def store_ideal_payment_status
    update(paid_by_ideal: true) if (payment && payment.paid?)
  end

  def reset_discount_codes
    students.map(&:reset_discount_code!)
  end
end
