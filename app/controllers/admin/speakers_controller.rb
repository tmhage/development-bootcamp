class Admin::SpeakersController < Admin::AdminController
  before_action :authenticate_user!
  before_filter :set_speaker, only: [:edit, :update, :destroy]

  def index
    @speakers = Speaker.order(created_at: :desc).page(page_number).per(10)
  end

  def new
    @speaker = Speaker.new
  end

  def edit
  end

  def create
    if Speaker.create(speaker_params)
      redirect_to admin_speakers_path, notice: 'Speaker created successfully'
    else
      render :new
    end
  end

  def update
    if @speaker.update(speaker_params)
      redirect_to admin_speakers_path, notice: 'Speaker updated successfully'
    else
      render :edit
    end
  end

  def destroy
    if @speaker.destroy
      redirect_to admin_speakers_path, notice: 'Speaker destroyed successfully'
    end
  end

  private

  def set_speaker
    @speaker = Speaker.find(params[:id])
  end

  def page_number
    (params[:page] || 1).to_i
  end

  def speaker_params
    params[:speaker][:activated_at] = Time.now if params[:speaker][:activated_at] == '1'
    params.require(:speaker).permit(:name, :description, :logo, :remarks, :email,
      :twitter_handle, :activated_at, :website)
  end
end
