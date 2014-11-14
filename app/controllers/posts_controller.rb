class PostsController < ApplicationController
  def index
    @posts = Post.published.page(page_number).per(10)
    render stream: true
  end

  def show
    @post = Post.published.friendly.find(params[:id])
    render stream: true
  end

  private

  def page_number
    (params[:page] || 1).to_i
  end
end
