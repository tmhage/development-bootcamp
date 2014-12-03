class Admin::StudentsController < Admin::AdminController
  before_action :authenticate_user!
  before_filter :set_student, only: [:edit, :update, :destroy]

  def index
    @students = Student.order(created_at: :desc).page(page_number).per(10)
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    if Student.create(student_params)
      redirect_to admin_students_path, notice: 'Student created successfully'
    else
      render :new
    end
  end

  def update
    if @student.update(student_params)
      redirect_to admin_students_path, notice: 'Student updated successfully'
    else
      render :edit
    end
  end

  def destroy
    if @student.destroy
      redirect_to admin_students_path, notice: 'Student destroyed successfully'
    end
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def page_number
    (params[:page] || 1).to_i
  end

  def student_params
    params.require(:student).
      permit(:first_name, :last_name, :email, :twitter_handle, :github_handle,
        :birth_date, :preferred_level, :remarks)
  end
end
