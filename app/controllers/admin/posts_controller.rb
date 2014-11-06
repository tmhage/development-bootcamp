class Admin::PostsController < ApplicationController
  before_action :authenticate_user!
  before_filter :set_post, only: [:show, :edit, :publish, :unpublish, :destroy]

  def index
    @posts = Post.recent
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def publish
    if @post.publish!
      redirect_to admin_posts_path, notice: "Post is successfully published."
    else
      redirect_to admin_posts_path, error: "Post could not be published."
    end
  end

  def unpublish
    if @post.unpublish!
      redirect_to admin_posts_path, notice: "Post is successfully unpublished."
    else
      redirect_to admin_posts_path, error: "Post could not be unpublished."
    end
  end

  def destroy
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end
end
