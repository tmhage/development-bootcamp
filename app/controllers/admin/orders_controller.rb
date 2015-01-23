class Admin::OrdersController < Admin::AdminController
  before_action :set_order, only: [:show, :edit, :destroy]

  respond_to :html

  def index
    @orders = Order.order(created_at: :desc).page(page_number).per(10)
    respond_with(@orders)
  end

  def show
    respond_with(@order)
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to @order
    else
      render 'edit'
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

  def page_number
    (params[:page] || 1).to_i
  end
end
