class Admin::UsersController < Admin::AdminController
  before_filter :load_user, only: [:edit, :update, :destroy]

  def index
    @users = User.order(created_at: :desc).page(page_number).per(10)
  end

  def new
    @user = User.new
    @user.build_user_profile
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User saved"
      redirect_to admin_users_path, notice: 'User created successfully'
    else
      render 'new'
    end
  end

  def edit; end

  def update
    update_params = user_params
    logger.debug update_params

    if update_params["password"].blank?
      update_params.delete("password")
      update_params.delete("password_confirmation")
    end

    if @user.update(update_params)
      redirect_to admin_users_path, notice: 'User updated successfully'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: 'User destroyed successfully'
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :id, :email, :password, :password_confirmation, :first_name, :last_name,
      user_profile_attributes: [:role, :twitter_handle, :linkedin_url, :github_handle, :core, :teacher, :coach])
  end

  def load_user
    @user = User.find(params[:id])
    @user.user_profile || @user.build_user_profile
  end

  def page_number
    (params[:page] || 1).to_i
  end
end
