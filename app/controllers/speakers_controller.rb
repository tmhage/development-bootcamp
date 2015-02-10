class SpeakersController < ApplicationController
  before_filter :set_subnav

  def index
    @speakers = Speaker.active
  end

  def new
    @speaker = Speaker.new
  end

  def create
    @speaker = Speaker.new(apply_as_speaker_params)

    if @speaker.save
      flash.notice = 'Thank you for registering. We will contact you soon!'
      add_to_list(@speaker)
      redirect_to thanks_speaker_path(@speaker)
    else
      flash.alert = 'Sorry, it seems something went wrong.'
      render action: 'new'
    end
  end

  def thanks
    disable_sidebar
    @speaker = Speaker.find(params[:id])
  end

  private

  def apply_as_speaker_params
    params.require(:speaker).
      permit(:first_name, :last_name, :email, :twitter_handle, :website, :remarks, :role, :bio)
  end

  def add_to_list(speaker)
    gb = Gibbon::API.new
    gb.lists.subscribe({
      :id => MailingLists::SPEAKERS,
      email: {
        email: speaker.email,
      },
      merge_vars: {
        FNAME: speaker.first_name,
        LNAME: speaker.last_name
      }
    })
  rescue Gibbon::MailChimpError => e
    logger.error "Could not add #{speaker.email} to speakers mailing list: #{e.message}"
  end

  def set_subnav
    @nav_items = {
      'Overview' => speakers_path,
      'Apply' => new_speaker_path
    }
  end
end
