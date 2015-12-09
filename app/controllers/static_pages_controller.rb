class StaticPagesController < ApplicationController

  before_filter :disable_sidebar

  def home
    @next_bootcamp = Bootcamp.published.by_date.first
    @reviews = Review.published.where(language: I18n.locale)
      .joins(:student, :bootcamp)
      .order(original_date: :desc)
      .limit(3)
  end

  def team; end

  def newsletter; end

  def open_evening; end

  def contact; end
end
