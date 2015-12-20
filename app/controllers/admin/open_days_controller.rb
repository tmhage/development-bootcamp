class Admin::OpenDaysController < Admin::AdminController
  before_action :set_open_day, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @open_days = OpenDay.upcoming
    respond_with(@open_days)
  end

  def show
    respond_with(@open_day)
  end

  def new
    @open_day = OpenDay.new
    @open_day.starts_at = Date.today.end_of_day - 239.minutes # 8pm
    @open_day.address = 'Weesperstraat 61, 1018 VN Amsterdam'
    @open_day.description_en = "
<ul>
  <li>20:00  — Doors Open</li>
  <li>20:30  — Welcome and Keynote</li>
  <li>21:15  — Q&amp;A and drinks</li>
</ul>"
  @open_day.description_nl = "
<ul>
  <li>20:00  — Deuren Open</li>
  <li>20:30  — Welkomst en Keynote</li>
  <li>21:15  — Q&amp;A en borrel</li>
</ul>"
    respond_with(@open_day)
  end

  def edit
  end

  def create
    @open_day = OpenDay.new(open_day_params)
    @open_day.save
    redirect_to admin_open_days_path
  end

  def update
    @open_day.update(open_day_params)
    redirect_to admin_open_days_path
  end

  def destroy
    @open_day.destroy
    respond_with(@open_day)
  end

  private
    def set_open_day
      @open_day = OpenDay.find(params[:id])
    end

    def open_day_params
      params.require(:open_day).permit(:starts_at, :address,
                                       :description_en, :description_nl,
                                       :facebook_event_url)
    end
end
