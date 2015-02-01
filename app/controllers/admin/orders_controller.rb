class Admin::OrdersController < Admin::AdminController
  include TicketMailer

  before_action :set_order, only: [:show, :edit, :destroy, :manually_paid, :paid_by_creditcard]

  respond_to :html

  def index
    @orders = Order.joins(:students).order(created_at: :desc).page(page_number).per(10)
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

  def manually_paid
    if @order.update(manually_paid: true)
      flash[:notice] = 'Status set to manually paid'
      send_tickets!
    else
      flash[:error] = 'Could not update status, try again'
    end
    redirect_to admin_orders_path
  end

  def paid_by_creditcard
    if @order.update(paid_by_creditcard: true)
      flash[:notice] = 'Status set to paid by creditcard'
      send_tickets!
    else
      flash[:error] = 'Could not update status, try again'
    end
    redirect_to admin_orders_path
  end

  private ###########################################################################################

  def set_order
    @order = Order.find_by_identifier(params[:id])
  end

  def order_params
    params.require(:order).permit(:price, :payed_at, :mollie_payment_id, :refunded_at, :mollie_refund_id,
      :billing_name, :billing_email, :billing_address, :billing_postal, :billing_city, :billing_country,
      :billing_phone, :billing_company_name, :confirmed_at, :terms_and_conditions,
      cart: [:early_bird, :normal, :supporter],
      students_attributes: [:first_name, :last_name, :email, :twitter_handle, :github_handle, :birth_date, :preferred_level, :remarks, :allergies])
  end

  def page_number
    (params[:page] || 1).to_i
  end
end
