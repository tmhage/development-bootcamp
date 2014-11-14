class Admin::SponsorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sponsors = Sponsor.all
  end
end
