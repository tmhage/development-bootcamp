class Admin::OrdersController < Admin::AdminController

  before_action :set_order, only: [:show, :edit, :update, :destroy, :manually_paid, :paid_by_creditcard, :send_invoice]

  respond_to :html

  def index
    @orders = Order.includes(:discount_code, :students, :bootcamp).
      order('bootcamps.starts_at desc, orders.created_at desc').
      page(page_number).per(10)

    respond_with(@orders)
  end

  def show
    respond_with(@order)
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order)
    else
      render 'edit'
    end
  end

  def destroy
    if @order && @order.destroy
      redirect_to admin_orders_path, notice: 'Order destroyed successfully.'
    else
      redirect_to admin_orders_path, error: 'Could not destroy order, please try again.'
    end
  end

  def manually_paid
    if @order.update(manually_paid: true)
      flash[:notice] = 'Status set to manually paid'
      send_invoice_and_tickets!
    else
      flash[:error] = 'Could not update status, try again'
    end
    redirect_to admin_orders_path
  end

  def paid_by_creditcard
    if @order.update(paid_by_creditcard: true)
      flash[:notice] = 'Status set to paid by creditcard'
      send_invoice_and_tickets!
    else
      flash[:error] = 'Could not update status, try again'
    end
    redirect_to admin_orders_path
  end

  def send_invoice
    if @order
      InvoiceMailWorker.perform_async(@order.id)
      redirect_to admin_orders_path, notice: 'Invoice queued for sending.'
    else
      redirect_to admin_orders_path, error: 'Could not find order, please try again.'
    end
  end

  private ###########################################################################################

  def set_order
    @order = Order.find_by_identifier(params[:id])
  end

  def order_params
    params.require(:order).permit(:price, :paid_at, :mollie_payment_id, :refunded_at, :mollie_refund_id,
      :billing_name, :billing_email, :billing_address, :billing_postal, :billing_city, :billing_country,
      :billing_phone, :billing_company_name, :confirmed_at, :terms_and_conditions, :bootcamp_id,
      cart: [:community, :normal, :supporter],
      students_attributes: [:first_name, :last_name, :email, :twitter_handle, :github_handle, :birth_date, :remarks, :allergies, :owns_laptop])
  end

  def page_number
    (params[:page] || 1).to_i
  end

  def send_invoice_and_tickets!
    InvoiceMailWorker.perform_async(@order.id)
    TicketMailWorker.perform_async(@order.id)
  end
end
