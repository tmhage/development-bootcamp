class PostsController < ApplicationController
  def index
    @posts = Post.page(page_number).per(10)
  end

  def show
    @post = Post.friendly.find(params[:id])
  end

  private

  def page_number
    (params[:page] || 1).to_i
  end
end
