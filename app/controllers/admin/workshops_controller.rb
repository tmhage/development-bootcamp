class Admin::WorkshopsController < Admin::AdminController
  before_action :authenticate_user!
  before_filter :set_workshop, only: [:edit, :show, :update, :destroy]

  def index
    @workshops = Workshop.all
  end

  def new
    @workshop = Workshop.new
  end

  def edit
  end

  def show
  end

  def create
    if Workshop.create(workshop_params)
      redirect_to admin_workshops_path, notice: 'Workshop created successfully'
    else
      render :new
    end
  end

  def update
    if @workshop.update(workshop_params)
      redirect_to admin_workshops_path, notice: 'Workshop updated successfully'
    else
      render :edit
    end
  end

  def destroy
    if @workshop.destroy
      redirect_to admin_workshops_path, notice: 'Workshop destroyed successfully'
    end
  end

  private

  def set_workshop
    @workshop = Workshop.friendly.find(params[:id])
  end

  def workshop_params
    params.require(:workshop).permit(:title, :description, :prerequisite,
      :outcome, :starts_at, :published)
  end
end
