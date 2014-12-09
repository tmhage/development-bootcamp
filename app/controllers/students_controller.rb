class StudentsController < ApplicationController
  def new
    @student = Student.new
  end

  def create
    @student = Student.new(apply_as_student_params)

    if @student.save
      flash.notice = 'Thank you for registering. We will contact you soon!'
      add_to_list(@student)
      redirect_to thanks_student_path(@student)
    else
      flash.alert = 'Sorry, it seems something went wrong.'
      render action: 'new'
    end
  end

  def thanks
    @student = Student.find(params[:id])
  end

  private

  def apply_as_student_params
    params.require(:student).
      permit(:first_name, :last_name, :email, :twitter_handle, :github_handle, :birth_date, :preferred_level, :remarks)
  end

  def add_to_list(student)
    gb = Gibbon::API.new
    gb.lists.subscribe({
      :id => MailingLists::STUDENTS,
      email: {
        email: student.email
      },
      merge_vars: {
        FNAME: student.first_name,
        LNAME: student.last_name
      }
    })
  rescue Gibbon::MailChimpError => e
    logger.error "Could not add #{student.email} to students mailing list: #{e.message}"
  end
end
