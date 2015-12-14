class ScholarshipsController < ApplicationController
  respond_to :html

  def thanks
    session[:scholarship_application_id] ||= 0
    @scholarship = Scholarship.find(session[:scholarship_application_id])
    respond_with(@scholarship)
  end

  def apply
    @scholarship = Scholarship.new
  end

  def create
    @scholarship = Scholarship.new(scholarship_params)
    if @scholarship.save
      session[:scholarship_application_id] = @scholarship.id
      redirect_to thanks_scholarships_path
    else
      render :apply
    end
  end

  private
    def scholarship_params
      params.require(:scholarship).permit(:first_name, :last_name, :email, :phone,
        :gender, :birth_date, :employment_status, :reason, :future_plans,
        :education_level, :full_program, :traineeship)
    end
end
