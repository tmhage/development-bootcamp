class PagesController < ApplicationController
  def show
    @page = Page.published.friendly.find(params[:id])
    page_not_found and return unless @page
  end
end
