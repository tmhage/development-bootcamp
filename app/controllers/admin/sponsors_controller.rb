class Admin::SponsorsController < Admin::AdminController
  before_action :authenticate_user!
  before_filter :set_sponsor, only: [:edit, :update, :destroy]

  def index
    @sponsors = Sponsor.order(created_at: :desc).page(page_number).per(10)
  end

  def new
    @sponsor = Sponsor.new
  end

  def edit
  end

  def create
    if Sponsor.create(sponsor_params)
      redirect_to admin_sponsors_path, notice: 'Sponsor created successfully'
    else
      render :new
    end
  end

  def update
    if @sponsor.update(sponsor_params)
      redirect_to admin_sponsors_path, notice: 'Sponsor updated successfully'
    else
      render :edit
    end
  end

  def destroy
    if @sponsor.destroy
      redirect_to admin_sponsors_path, notice: 'Sponsor destroyed successfully'
    end
  end

  private

  def set_sponsor
    @sponsor = Sponsor.friendly.find(params[:id])
  end

  def page_number
    (params[:page] || 1).to_i
  end

  def sponsor_params
    params[:sponsor][:activated_at] = Time.now if params[:sponsor][:activated_at] == '1'
    params.require(:sponsor).permit(:first_name, :last_name, :name, :description, :logo, :remarks, :email,
      :hiring, :activated_at, :website, :plan)
  end
end
