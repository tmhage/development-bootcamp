class ScholarshipsController < ApplicationController
  respond_to :html

  def thanks
    session[:scholarship_application_id] ||= 0
    mixpanel.track '[applies] Scholarship Application', scholarship_id: session[:scholarship_application_id]
    @scholarship = Scholarship.find(session[:scholarship_application_id])
    respond_with(@scholarship)
  end

  def apply
    @scholarship = Scholarship.new
    mixpanel.track '[visits] Scholarship Application Page'
  end

  def create
    @scholarship = Scholarship.new(scholarship_params)
    if @scholarship.save
      session[:scholarship_application_id] = @scholarship.id
      TraineeshipMailWorker.perform_async(@scholarship.id)
      redirect_to thanks_scholarships_path
    else
      render :apply
    end
  end

  private
    def scholarship_params
      params.require(:scholarship).permit(:first_name, :last_name, :email, :phone,
        :gender, :birth_date, :employment_status, :reason, :future_plans,
        :education_level, :full_program, :traineeship, :linked_in_profile_url,
        coding_experience: [])
    end
end
