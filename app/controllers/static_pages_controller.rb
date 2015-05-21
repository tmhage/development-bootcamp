class StaticPagesController < ApplicationController

  before_filter :disable_sidebar

  def home
    @sponsors = Sponsor.active
  end

  def about; end

  def team; end

  def newsletter; end

  def code_of_conduct; end

  def cancellation_policy; end

  def terms_and_conditions; end

  def contact; end
end
