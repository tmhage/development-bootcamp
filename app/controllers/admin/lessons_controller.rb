class Admin::LessonsController < Admin::AdminController
  before_action :authenticate_user!
  before_filter :set_lesson, only: [:edit, :update, :destroy]

  def index
    @lessons = Lesson.all
  end

  def new
    @lesson = Lesson.new
  end

  def edit
  end

  def create
    if Lesson.create(lesson_params)
      redirect_to admin_lessons_path, notice: 'Lesson created successfully'
    else
      render :new
    end
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to admin_lessons_path, notice: 'Lesson updated successfully'
    else
      render :edit
    end
  end

  def destroy
    if @lesson.destroy
      redirect_to admin_lessons_path, notice: 'Lesson destroyed successfully'
    end
  end

  private

  def set_lesson
    @lesson = Lesson.friendly.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :description,
      :starts_at, :published, :starts_at, :duration, :workshop_id)
  end
end
