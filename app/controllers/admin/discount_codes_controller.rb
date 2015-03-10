class Admin::DiscountCodesController < Admin::AdminController
  before_action :set_discount_code, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @discount_codes = DiscountCode.all
    respond_with(@discount_codes)
  end

  def show
    respond_with(@discount_code)
  end

  def new
    @discount_code = DiscountCode.new
    respond_with(@discount_code)
  end

  def edit
  end

  def create
    @discount_code = DiscountCode.new(discount_code_params)
    @discount_code.save
    respond_with(:admin, @discount_code)
  end

  def update
    @discount_code.update(discount_code_params)
    respond_with(:admin, @discount_code)
  end

  def destroy
    @discount_code.destroy
    respond_with(:admin, @discount_code)
  end

  private
    def set_discount_code
      @discount_code = DiscountCode.find(params[:id])
    end

    def discount_code_params
      params.require(:discount_code).permit(:code, :discount_percentage, :slug, :valid_until)
    end
end
