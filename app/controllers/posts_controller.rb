class PostsController < ApplicationController
  def index
    @posts = Post.published.page(page_number).per(10)
  end

  def show
    @post = Post.published.friendly.find(params[:id])
  end

  private

  def page_number
    (params[:page] || 1).to_i
  end
end
