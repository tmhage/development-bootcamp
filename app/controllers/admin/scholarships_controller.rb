class Admin::ScholarshipsController < Admin::AdminController
  before_action :set_scholarship, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @scholarships = Scholarship.by_status.decorate
    respond_with(@scholarships)
  end

  def show
    @note = @scholarship.notes.build
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
    respond_with(:admin, @scholarship)
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
        :education_level, :full_program, :traineeship, :status, :bootcamp_id,
        :linked_in_profile_url, coding_experience: [],
        notes_attributes: [:body, :user_id])
    end
end
