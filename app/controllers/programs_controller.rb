class ProgramsController < ApplicationController
  before_filter :set_subnav

  def index; end

  def level_one; end
  def level_two; end
  def level_three; end
  def level_four; end

  private

  def set_subnav
    @nav_items = {
      'Overview' => program_path,
      'Level 1' => program_level_1_path,
      'Level 2' => program_level_2_path,
      'Level 3' => program_level_3_path,
      'Level 4' => program_level_4_path
    }
  end
end
