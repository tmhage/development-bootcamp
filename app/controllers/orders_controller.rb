class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :thanks, :stripe_token]

  protect_from_forgery with: :exception, except: [:webhook, :stripe_webhook]

  respond_to :html

  def show
    respond_with(@order)
  end

  def new
    session.delete(:order_step) && session.delete(:order_params)
    session[:order_params] ||= {}
    @order = Order.new(session[:order_params])
    @order.current_step = session[:order_step]
    respond_with(@order)
  end

  def create
    session[:order_params].deep_merge!(order_params) if order_params
    @order = Order.new(session[:order_params])

    (@order.cart_sum_tickets - @order.students.size).times { @order.students.build } if @order.cart_sum_tickets > 0

    @order.current_step = session[:order_step]

    if params[:back_button]
      @order.previous_step
    elsif @order.last_step?
      @order.confirmed_at = Time.now
      @order.price = @order.cart_sum_total
      @order.save
    else
      @order.next_step unless (@order.current_step == 'tickets' && (@order.cart_sum_tickets == 0 || !@order.cart_has_positive_amounts_for_tickets?))
    end
    session[:order_step] = @order.current_step

    @order.valid? if @order.current_step == 'confirmation'

    if @order.persisted?
      flash[:notice] = "Thank you for your registration!"

      # reset session
      session.delete(:order_step)
      session.delete(:order_params)

      # add students to mailing list
      @order.students.each { |student| add_to_list(student) }
      redirect_to ticket_url(@order)
    else
      render 'new'
    end
  end

  def webhook
    @order = Order.find_by_mollie_payment_id(params[:id])
    success = @order.update(mollie_status: @order.payment.status)
    render json: { success: success }
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
end
