class ProgramsController < ApplicationController
  before_filter :set_subnav

  def index; end

  def level_one
    @level = 'Beginner'
    @bootcamps = Bootcamp.beginner.published.by_date
    set_reviews(1)
  end

  def level_two
    @level = 'Intermediate'
    @bootcamps = Bootcamp.intermediate.published.by_date
    set_reviews(2)
  end

  def level_three
    @level = 'Advanced'
    @bootcamps = Bootcamp.advanced.published.by_date
    set_reviews(3)
  end

  def frontend_bootcamp
    @level = 'Frontend'
    @bootcamps = Bootcamp.frontend.published.by_date
    set_reviews(99)
  end

  private

  def set_reviews(level)
    @reviews = Review.published.where(language: I18n.locale)
      .joins(:student, :bootcamp)
      .where(bootcamps: { level: level })
      .order(original_date: :desc)
  end

  def set_subnav
    @nav_items = {
      'Overview' => courses_path
    }
  end
end
