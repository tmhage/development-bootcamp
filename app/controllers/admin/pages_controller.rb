class Admin::PagesController < Admin::AdminController
  before_filter :set_page, only: [:edit, :update, :publish, :unpublish, :destroy]

  def index
    @pages = Page.order('title asc')
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    if @page.save
      redirect_to admin_pages_path, notice: "Page created successfully"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_pages_path, notice: "Page updated successfully"
    else
      render :edit
    end
  end

  def publish
    if @page.publish!
      redirect_to admin_pages_path, notice: "Page is successfully published."
    else
      redirect_to admin_pages_path, error: "Page could not be published."
    end
  end

  def unpublish
    if @page.unpublish!
      redirect_to admin_pages_path, notice: "Page is successfully unpublished."
    else
      redirect_to admin_pages_path, error: "Page could not be unpublished."
    end
  end

  def destroy
    if @page.destroy!
      redirect_to admin_pages_path, notice: "Page is successfully destroyed."
    else
      redirect_to admin_pages_path, error: "Page could not be destroyed."
    end
  end

  private

  def set_page
    @page = Page.friendly.find(params[:id])
  end

  def page_params
    params.require(:page).permit(
      :id, :title, :slug, :body, :dutch_version, :published)
  end
end
