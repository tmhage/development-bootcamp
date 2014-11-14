class SponsorsController < ApplicationController
  def index
    @sponsors = Sponsor.active
  end

  def show
    @post = Sponsor.friendly.find(params[:id])
  end

  def new
    @sponsor = Sponsor.new
  end

  def create
    sponsor = Sponsor.new(apply_as_sponsor_params)
    if sponsor.save!
      flash.notice = "Thank you for registering. We will contact you soon!"
    else
      flash.alert = "Sorry, it seems something went wrong."
    end
    redirect_to sponsors_path
  end

  private

  def apply_as_sponsor_params
    params.require(:sponsor).permit(:name, :email, :contact_person,
      :phone_number, :remarks)
  end
end
