class StaticPagesController < ApplicationController

  before_filter :disable_sidebar

  def home
    @next_bootcamp = Bootcamp.published.by_date.first
    @reviews = Review.published.where(language: I18n.locale)
      .joins(:student, :bootcamp)
      .order(original_date: :desc)
      .limit(3)
    mixpanel.track '[visits] Home Page'
  end

  def team
    mixpanel.track '[visits] Team Page'
  end

  def newsletter
    mixpanel.track '[visits] Newsletter Page'
  end

  def open_evening
    mixpanel.track '[visits] Open Evening Page'
  end

  def contact
    mixpanel.track '[visits] Help & Support Page'
  end
end
