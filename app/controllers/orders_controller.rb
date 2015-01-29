class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :thanks, :stripe_token]

  protect_from_forgery with: :exception, except: [:webhook, :stripe_webhook]

  respond_to :html

  def show
    respond_with(@order)
  end

  def new
    session[:order_params] ||= {}
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]
    respond_with(@order)
  end

  def create
    session[:order_params].deep_merge!(order_params) if order_params

    @order = Order.new(session[:order_params])

    build_students

    @order.current_step = session[:order_step]

    if params[:back_button]
      @order.previous_step
      @order.valid?
    end

    if @order.last_step?
      finish_up_after_confirmation
      @order.save
    end

    @order.next_step unless params[:back_button] ||
      (@order.current_step == 'tickets' && !@order.cart_has_positive_amounts_for_tickets?)
    session[:order_step] = @order.current_step

    @order.valid? if @order.current_step == 'confirmation'

    if @order.persisted?
      flash[:notice] = "Thank you for your registration!"
      reset_order_session!
      @order.students.each { |student| add_to_list(student) }
      redirect_to ticket_url(@order)
    else
      render 'new'
    end
  end

  def webhook
    @order = Order.find_by_mollie_payment_id(params[:id])
    if @order.present?
      @order.update(mollie_status: @order.payment.status)
    end
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
    params.require(:order).permit(:price, :payed_at, :mollie_payment_id, :refunded_at, :mollie_refund_id,
      :billing_name, :billing_email, :billing_address, :billing_postal, :billing_city, :billing_country,
      :billing_phone, :billing_company_name, :confirmed_at, cart: [:early_bird, :normal, :supporter],
      students_attributes: [:first_name, :last_name, :email, :twitter_handle, :github_handle, :birth_date, :preferred_level, :remarks, :allergies])
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
    amount_to_build = @order.cart_sum_tickets - @order.students.size
    return if amount_to_build <= 0
    amount_to_build.times { @order.students.build }
  end

  def finish_up_after_confirmation
    @order.confirmed_at = Time.now
    @order.price = @order.cart_sum_total
  end

  def reset_order_session!
    session.delete(:order_step)
    session.delete(:order_params)
  end
end
