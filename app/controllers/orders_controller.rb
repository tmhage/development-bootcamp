class OrdersController < ApplicationController

  before_filter :disable_sidebar

  before_action :set_order, only: [:show, :thanks, :stripe_token]

  protect_from_forgery with: :exception, except: [:webhook, :stripe_webhook]

  respond_to :html

  def show
    respond_with(@order)
  end

  def new
    @bootcamps = Bootcamp.where('starts_at > NOW()').order(starts_at: :asc)
    reset_order_session!
    session[:order_params] ||= {}
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]
    @order.bootcamp = @bootcamps.first

    if params[:promo].present?
      @order.promo_code = params[:promo]
      @order.validate_discount_code
    end

    respond_with(@order)
  end

  def create
    @bootcamps = Bootcamp.where('starts_at > NOW()').order(starts_at: :asc)
    session[:order_params].deep_merge!(order_params) if order_params

    @order = Order.new(session[:order_params])

    @order.current_step = session[:order_step]

    if params[:back_button]
      @order.previous_step
      build_students
      @order.valid?
    elsif @order.last_step?
      finish_up_after_confirmation
      @order.save
    elsif @order.validating_promo_code?
      @order.validate_discount_code
      @order.validate_promo_code = nil # reset
    elsif @order.selecting_bootcamp?
      @order.select_bootcamp = nil # reset
    else
      build_students
      @order.next_step if @order.valid?
    end

    session[:order_step] = @order.current_step

    if @order.persisted?
      flash[:notice] = "Thank you for your registration!"
      reset_order_session!
      enqueue_payment_email!
      @order.students.each { |student| add_to_list(student) }
      redirect_to ticket_url(@order)
    else
      render :new
    end
  end

  def webhook
    @order = Order.find_by_mollie_payment_id(params[:id])
    if @order.present?
      payment_status = @order.payment.status
      send_invoice_and_tickets! if @order.payment.paid? && @order.mollie_status != 'paid'
      @order.update(mollie_status: payment_status)
    end
  rescue Mollie::API::Exception => error
    Appsignal.add_exception error
    Rails.logger.info error.message
  ensure
    render text: 'OK'
  end

  def stripe_webhook
    # This will fail, but we will see it in AppSignal and be able to fix it properly.
    # Stripe's webhook tests are useless.
    if params[:object] == 'event'
      if params[:type] == 'charge.succeeded'
        @order.payed_at = Time.now
        @order.stripe_payload = params
        @order.save!
      end
    end
  end

  def thanks
  end

  def stripe_token
    if params[:stripeToken].present?
      if @order.update(stripe_token: params[:stripeToken])
        enqueue_creditcard_charge!
        flash[:notice] = "Thank you for your registration!"
      else
        flash[:error] = "Sorry, your creditcard payment could not be processed, please contact us at support@developmentbootcamp.nl"
      end
    else
      flash[:error] = "Sorry, your creditcard payment could not be processed, please try again or contact us at support@developmentbootcamp.nl"
    end
    redirect_to ticket_url(@order)
  end

  private ###########################################################################################

  def set_order
    @order = Order.find_by_identifier(params[:id])
  end

  def order_params
    params.require(:order).permit(:price, :promo_code, :payed_at, :mollie_payment_id, :refunded_at, :mollie_refund_id,
      :billing_name, :billing_email, :billing_address, :billing_postal, :billing_city, :billing_country, :validate_promo_code,
      :billing_phone, :billing_company_name, :confirmed_at, :terms_and_conditions, :bootcamp_id, :select_bootcamp,
      cart: [:community, :normal, :supporter],
      students_attributes: [:first_name, :last_name, :email, :twitter_handle, :github_handle, :birth_date,
        :remarks, :allergies, :owns_laptop])
  end

  def add_to_list(student)
    gb = Gibbon::API.new
    gb.lists.subscribe({
      :id => MailingLists::STUDENTS,
      email: {
        email: student.email
      },
      merge_vars: {
        FNAME: student.first_name,
        LNAME: student.last_name
      }
    })
  rescue Gibbon::MailChimpError => e
    logger.error "Could not add #{student.email} to students mailing list: #{e.message}"
  end

  def build_students
    if @order.current_step =~ /^students/
      student_index = @order.current_step.split('-').last.to_i + 1
    else
      student_index = 0
    end
    amount_to_build = @order.cart_sum_tickets - @order.students.size
    amount_to_build.times { @order.students.build }
    students_to_take = @order.students.to_a.first(student_index)
    @order.students = []
    students_to_take.each do |student|
      @order.students << student
    end
  end

  def finish_up_after_confirmation
    @order.confirmed_at = Time.now
    @order.price = @order.cart_sum_total
  end

  def reset_order_session!
    session.delete(:order_step)
    session.delete(:order_params)
  end

  def send_invoice_and_tickets!
    InvoiceMailWorker.perform_async(@order.id)
    TicketMailWorker.perform_async(@order.id)
  end

  def enqueue_payment_email!
    FollowupMailWorker.perform_in(1.hour, @order.id)
  end

  def enqueue_creditcard_charge!
    CreditcardChargerWorker.perform_async(@order.id)
  end
end
