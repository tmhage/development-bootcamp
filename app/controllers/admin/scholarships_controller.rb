class Admin::ScholarshipsController < Admin::AdminController
  before_action :set_scholarship, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scholarships = Scholarship.all.order(created_at: :desc).decorate
    respond_with(@scholarships)
  end

  def show
    respond_with(@scholarship)
  end

  def new
    @scholarship = Scholarship.new
    respond_with(@scholarship)
  end

  def edit
  end

  def create
    @scholarship = Scholarship.new(scholarship_params)
    @scholarship.save
    respond_with(:admin, @scholarship)
  end

  def update
    @scholarship.update(scholarship_params)
    redirect_to admin_scholarships_path
  end

  def destroy
    @scholarship.destroy
    respond_with(@scholarship)
  end

  private
    def set_scholarship
      @scholarship = Scholarship.find(params[:id])
    end

    def scholarship_params
      params.require(:scholarship).permit(:first_name, :last_name, :email, :phone,
        :gender, :birth_date, :employment_status, :reason, :future_plans,
        :education_level, :full_program, :traineeship, :status, :bootcamp_id)
    end
end
