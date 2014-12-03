class SponsorsController < ApplicationController
  def index
    @sponsors = Sponsor.active
  end

  def new
    @sponsor = Sponsor.new
  end

  def create
    @sponsor = Sponsor.new(apply_as_sponsor_params)

    if @sponsor.save
      flash.notice = 'Thank you for registering. We will contact you soon!'
      add_to_list(@sponsor)
      redirect_to sponsors_path
    else
      flash.alert = 'Sorry, it seems something went wrong.'
      render action: 'new'
    end
  end

  private

  def apply_as_sponsor_params
    params.require(:sponsor).permit(:name, :email, :website, :remarks)
  end

  def add_to_list(sponsor)
    gb = Gibbon::API.new
    gb.lists.subscribe({
      :id => MailingLists::SPONSORS,
      email: {
        email: sponsor.email
      },
      merge_vars: {
        FNAME: sponsor.first_name,
        LNAME: sponsor.last_name
      }
    })
  rescue Gibbon::MailChimpError => e
    logger.error "Could not add #{sponsor.email} to sponsors mailing list: #{e.message}"
  end
end
