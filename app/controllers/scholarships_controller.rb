class ScholarshipsController < ApplicationController
  before_action :set_scholarship, only: [:show]

  respond_to :html

  def show
    respond_with(@scholarship)
  end

  def new
    @scholarship = Scholarship.new
    respond_with(@scholarship)
  end

  def create
    @scholarship = Scholarship.new(scholarship_params)
    @scholarship.save
    respond_with(@scholarship)
  end

  private
    def set_scholarship
      @scholarship = Scholarship.find(params[:id])
    end

    def scholarship_params
      params.require(:scholarship).permit(:first_name, :last_name, :email, :phone, :gender, :birth_date, :employment_status, :reason, :future_plans, :full_program, :traineeship, :bootcamp_id)
    end
end
