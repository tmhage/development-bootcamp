class SponsorsController < ApplicationController
  before_filter :set_subnav

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
    @sponsor = Sponsor.friendly.find(params[:id])
  end

  private

  def apply_as_sponsor_params
    params.require(:sponsor).permit(:first_name, :last_name, :name, :email, :website, :remarks, :plan)
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

  def set_subnav
    @nav_items = {
      'Overview' => sponsors_path,
      'Plans' => plans_sponsors_path,
      'Apply' => new_sponsor_path
    }
  end
end
