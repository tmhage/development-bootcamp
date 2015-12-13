class PostsController < ApplicationController
  def index
    @posts = Post.published.page(page_number).order('published_at DESC').per(10).page(page_number)
    if page_number == 1 && params[:page].present?
      redirect_to blog_index_path and return
    end

    if page_number > 1 && @posts.count == 0
      page_not_found and return
    end

    mixpanel.track '[visits] Blog Index'
  end

  def show
    @post = Post.friendly.find(params[:id])
    if @post.language.to_sym != I18n.locale
      other_locale = I18n.locale == :en ? :nl : :en
      redirect_to blog_url(@post, host: Rails.application.config.hosts[other_locale]).sub('/nl/', '/'), status: :moved_permanently
    elsif @post.published?
      mixpanel.track '[visits] Blog Post', title: @post.title
      render :show
    else
      page_not_found
    end
  end

  private

  def page_number
    (params[:page] || 1).to_i
  end
end
