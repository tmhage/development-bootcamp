class SponsorsController < ApplicationController
  def index
    @sponsors = Sponsor.active
  end

  def plans; end

  def new
    @sponsor = Sponsor.new
  end

  def create
    @sponsor = Sponsor.new(apply_as_sponsor_params)

    if @sponsor.save
      flash.notice = 'Thank you for registering. We will contact you soon!'
      add_to_list(@sponsor)
      redirect_to thanks_sponsor_path(@sponsor)
    else
      flash.alert = 'Sorry, it seems something went wrong.'
      render action: 'new'
    end
  end

  def thanks
    disable_sidebar
    @sponsor = Sponsor.friendly.find(params[:id])
  end

  private

  def apply_as_sponsor_params
    params.require(:sponsor).permit(:first_name, :last_name, :name, :email, :website, :remarks, :plan)
  end

  def add_to_list(sponsor)
    gb = Gibbon::Request.new
    gb.lists(MailingLists::SPONSORS).members.create({
      email_address: sponsor.email,
      status: :subscribed,
      merge_fields: {
        FNAME: sponsor.first_name,
        LNAME: sponsor.last_name
      }
    })
  rescue Gibbon::MailChimpError => e
    logger.error "Could not add #{sponsor.email} to sponsors mailing list: #{e.message}"
  end
end
