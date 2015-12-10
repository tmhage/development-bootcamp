class Admin::ScholarshipsController < Admin::AdminController
  before_action :set_admin_scholarship, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @admin_scholarships = Admin::Scholarship.all
    respond_with(@admin_scholarships)
  end

  def show
    respond_with(@admin_scholarship)
  end

  def new
    @admin_scholarship = Admin::Scholarship.new
    respond_with(@admin_scholarship)
  end

  def edit
  end

  def create
    @admin_scholarship = Admin::Scholarship.new(scholarship_params)
    @admin_scholarship.save
    respond_with(@admin_scholarship)
  end

  def update
    @admin_scholarship.update(scholarship_params)
    respond_with(@admin_scholarship)
  end

  def destroy
    @admin_scholarship.destroy
    respond_with(@admin_scholarship)
  end

  private
    def set_admin_scholarship
      @admin_scholarship = Admin::Scholarship.find(params[:id])
    end

    def admin_scholarship_params
      params.require(:admin_scholarship).permit(:first_name, :last_name, :email, :phone, :gender, :birth_date, :employment_status, :reason, :future_plans, :full_program, :traineeship, :bootcamp_id, :approved)
    end
end
