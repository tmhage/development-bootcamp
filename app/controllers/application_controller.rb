class ApplicationController < ActionController::Base

  layout :set_layout

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :load_sponsors

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  def sitemap; end

  protected

  def page_not_found(exception = nil)
    if /\.(jpe?g|png|gif)/i === request.path
      render text: "404 Not Found", status: 404
    else
      respond_to do |format|
        format.html { render template: "errors/404", layout: 'application', status: 404 }
        format.json { render json: {status: 404, message: 'Resource not found'}, status: 404 }
        format.xml { render xml: {status: 404, message: 'Resource not found'}, status: 404 }
        format.rss { render xml: {status: 404, message: 'Resource not found'}, status: 404 }
      end
    end
  end

  def set_layout
    return 'admin' if devise_controller?
    'application'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:password, :password_confirmation, :current_password, :email,
        :first_name, :last_name)
    end
  end

  def disable_sidebar
    @show_sidebar = false
  end

  def load_sponsors
    @sponsors = Sponsor.active
  end
end
