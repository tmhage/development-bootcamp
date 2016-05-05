class ProgramsController < ApplicationController
  before_filter :set_subnav

  def index
    mixpanel.track '[visits] Course Index'
  end

  def level_one
    @level = 'Beginner'
    @bootcamps = Bootcamp.beginner.published.by_date
    set_reviews(1)
    mixpanel.track '[visits] Course Page', level: @level
  end

  def level_two
    @level = 'Intermediate'
    @bootcamps = Bootcamp.intermediate.published.by_date
    set_reviews(2)
    mixpanel.track '[visits] Course Page', level: @level
  end

  def level_three
    @level = 'Advanced'
    @bootcamps = Bootcamp.advanced.published.by_date
    set_reviews(3)
    mixpanel.track '[visits] Course Page', level: @level
  end

  def frontend_bootcamp
    @level = 'Frontend'
    mixpanel.track '[visits] Course Page', level: @level
    redirect_to courses_path, notice: t(:course_no_longer_exists), status: :moved_permanently
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
