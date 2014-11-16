class Admin::PostsController < Admin::AdminController
  before_filter :set_post, only: [:edit, :update, :publish, :unpublish, :destroy]

  def index
    @posts = Post.recent
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to admin_posts_path, notice: "Post created successfully"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to admin_posts_path, notice: "Post updated successfully"
    else
      render :edit
    end
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
    if @post.destroy!
      redirect_to admin_posts_path, notice: "Post is successfully destroyed."
    else
      redirect_to admin_posts_path, error: "Post could not be destroyed."
    end
  end

  private

  def set_post
    @post = Post.friendly.find(params[:id])
  end

  def post_params
    parameters = params.require(:post).permit(
      :id, :title, :slug, :content, :cover_image, :published, :unpublished)
    parameters['published_at'] = Time.now if parameters['published'] == '1' && @post && @post.unpublished?
    parameters['unpublished_at'] = Time.now if parameters['published'] == '0' && @post && @post.published?
    parameters.delete('published')
    parameters
  end
end
