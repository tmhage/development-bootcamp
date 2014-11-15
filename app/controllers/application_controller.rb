class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :page_not_found

  def page_not_found(exception = nil)
    if /(jpe?g|png|gif)/i === request.path
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
end
