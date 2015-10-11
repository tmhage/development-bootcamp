class ProgramsController < ApplicationController
  before_filter :set_subnav

  def index; end

  def level_one
    @bootcamps = Bootcamp.beginner.published
  end

  def level_two
  end

  def level_three
  end

  def level_four
    redirect_to program_path, status: :moved_permanently
  end

  private

  def set_subnav
    @nav_items = {
      'Overview' => program_path
    }
  end
end
