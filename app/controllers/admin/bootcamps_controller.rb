class Admin::BootcampsController < Admin::AdminController
  before_action :set_bootcamp, only: [:show, :edit, :update, :destroy, :publish, :unpublish]

  respond_to :html

  def index
    @bootcamps = Bootcamp.where('ends_at > NOW()').order(starts_at: :asc)
    respond_with(@bootcamps)
  end

  def show
    respond_with(@bootcamp)
  end

  def new
    @bootcamp = Bootcamp.new
    respond_with(@bootcamp)
  end

  def edit
  end

  def create
    @bootcamp = Bootcamp.new(bootcamp_params)
    @bootcamp.save
    respond_with(:admin, @bootcamp)
  end

  def update
    @bootcamp.update(bootcamp_params)
    respond_with(:admin, @bootcamp)
  end

  def publish
    @bootcamp.publish!
    redirect_to action: :index
  end

  def unpublish
    @bootcamp.unpublish!
    redirect_to action: :index
  end

  def destroy
    @bootcamp.destroy
    respond_with(:admin, @bootcamp)
  end

  private
    def set_bootcamp
      @bootcamp = Bootcamp.find(params[:id])
    end

    def bootcamp_params
      params.require(:bootcamp).permit(:name, :starts_at, :ends_at, :location,
        :level, :community_price, :normal_price, :supporter_price, :published_at,
        :unpublish)
    end
end
