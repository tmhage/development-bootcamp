class StaticPagesController < ApplicationController

  before_filter :disable_sidebar

  def home
    @next_bootcamp = Bootcamp.published.by_date.first
  end

  def about; end

  def team; end

  def newsletter; end

  def code_of_conduct; end

  def cancellation_policy; end

  def terms_and_conditions; end

  def contact; end
end
